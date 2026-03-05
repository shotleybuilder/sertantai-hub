defmodule SertantaiHubWeb.AuthProxyController do
  use SertantaiHubWeb, :controller

  defp auth_url,
    do: Application.get_env(:sertantai_hub, :auth_service_url, "http://localhost:4000")

  # Public-facing auth URL for browser redirects (not internal Docker networking)
  defp auth_public_url,
    do: Application.get_env(:sertantai_hub, :auth_public_url, auth_url())

  defp req_opts do
    case Application.get_env(:sertantai_hub, :auth_proxy_req_plug) do
      nil -> []
      plug -> [plug: plug]
    end
  end

  def github_redirect(conn, _params) do
    redirect_url = auth_public_url() <> "/api/auth/user/github"

    conn
    |> put_resp_header("location", redirect_url)
    |> send_resp(302, "")
  end

  def register(conn, params) do
    proxy_post(conn, "/api/auth/user/password/register", params)
  end

  def sign_in(conn, params) do
    proxy_post(conn, "/api/auth/user/password/sign_in", params)
  end

  def sign_out(conn, _params) do
    proxy_post(conn, "/api/sign_out", %{}, auth_header(conn))
  end

  def refresh(conn, params) do
    proxy_post(conn, "/api/refresh", params, auth_header(conn))
  end

  def magic_link_request(conn, params) do
    proxy_post(conn, "/api/auth/user/magic_link/request", params)
  end

  def magic_link_callback(conn, params) do
    proxy_post(conn, "/api/auth/user/magic_link", params)
  end

  def totp_status(conn, _params) do
    proxy_get(conn, "/api/totp/status", auth_header(conn))
  end

  def totp_setup(conn, _params) do
    proxy_post(conn, "/api/totp/setup", %{}, auth_header(conn))
  end

  def totp_enable(conn, params) do
    proxy_post(conn, "/api/totp/enable", params, auth_header(conn))
  end

  def totp_disable(conn, params) do
    proxy_post(conn, "/api/totp/disable", params, auth_header(conn))
  end

  def totp_challenge(conn, params) do
    proxy_post(conn, "/api/totp/challenge", params)
  end

  def totp_recover(conn, params) do
    proxy_post(conn, "/api/totp/recover", params)
  end

  def profile_show(conn, _params) do
    proxy_get(conn, "/api/profile", auth_header(conn))
  end

  def profile_update(conn, params) do
    proxy_patch(conn, "/api/profile", params, auth_header(conn))
  end

  def change_password(conn, params) do
    proxy_post(conn, "/api/profile/change-password", params, auth_header(conn))
  end

  def organization_show(conn, _params) do
    proxy_get(conn, "/api/organization", auth_header(conn))
  end

  def organization_update(conn, params) do
    proxy_patch(conn, "/api/organization", params, auth_header(conn))
  end

  # -- Admin endpoints (proxied to auth service) --

  def admin_list_users(conn, _params) do
    proxy_get(conn, "/api/admin/users", auth_header(conn))
  end

  def admin_show_user(conn, %{"id" => id}) do
    proxy_get(conn, "/api/admin/users/#{id}", auth_header(conn))
  end

  def admin_change_role(conn, %{"id" => id} = params) do
    body = Map.take(params, ["role"])
    proxy_patch(conn, "/api/admin/users/#{id}/role", body, auth_header(conn))
  end

  def admin_revoke_tokens(conn, %{"id" => id}) do
    proxy_post(conn, "/api/admin/users/#{id}/revoke-tokens", %{}, auth_header(conn))
  end

  def admin_kill_user(conn, %{"id" => id}) do
    proxy_post(conn, "/api/admin/users/#{id}/kill", %{}, auth_header(conn))
  end

  def admin_unkill_user(conn, %{"id" => id}) do
    proxy_post(conn, "/api/admin/users/#{id}/unkill", %{}, auth_header(conn))
  end

  defp proxy_get(conn, path, headers) do
    url = auth_url() <> path

    req_headers =
      [{"content-type", "application/json"}] ++ headers

    case Req.get(url, [headers: req_headers, receive_timeout: 10_000] ++ req_opts()) do
      {:ok, %Req.Response{status: status, body: resp_body}} ->
        conn
        |> put_status(status)
        |> json(resp_body)

      {:error, %Req.TransportError{reason: reason}} ->
        conn
        |> put_status(502)
        |> json(%{status: "error", message: "Auth service unavailable", reason: inspect(reason)})

      {:error, reason} ->
        conn
        |> put_status(502)
        |> json(%{status: "error", message: "Auth service error", reason: inspect(reason)})
    end
  end

  defp proxy_patch(conn, path, body, headers) do
    url = auth_url() <> path

    req_headers =
      [{"content-type", "application/json"}] ++ headers

    case Req.patch(url, [json: body, headers: req_headers, receive_timeout: 10_000] ++ req_opts()) do
      {:ok, %Req.Response{status: status, body: resp_body}} ->
        conn
        |> put_status(status)
        |> json(resp_body)

      {:error, %Req.TransportError{reason: reason}} ->
        conn
        |> put_status(502)
        |> json(%{status: "error", message: "Auth service unavailable", reason: inspect(reason)})

      {:error, reason} ->
        conn
        |> put_status(502)
        |> json(%{status: "error", message: "Auth service error", reason: inspect(reason)})
    end
  end

  defp proxy_post(conn, path, body, headers \\ []) do
    url = auth_url() <> path

    req_headers =
      [{"content-type", "application/json"}] ++ headers

    case Req.post(url, [json: body, headers: req_headers, receive_timeout: 10_000] ++ req_opts()) do
      {:ok, %Req.Response{status: status, body: resp_body}} ->
        conn
        |> put_status(status)
        |> json(resp_body)

      {:error, %Req.TransportError{reason: reason}} ->
        conn
        |> put_status(502)
        |> json(%{status: "error", message: "Auth service unavailable", reason: inspect(reason)})

      {:error, reason} ->
        conn
        |> put_status(502)
        |> json(%{status: "error", message: "Auth service error", reason: inspect(reason)})
    end
  end

  defp auth_header(conn) do
    case get_req_header(conn, "authorization") do
      [token] -> [{"authorization", token}]
      _ -> []
    end
  end
end
