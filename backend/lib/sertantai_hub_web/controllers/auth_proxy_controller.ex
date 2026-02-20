defmodule SertantaiHubWeb.AuthProxyController do
  use SertantaiHubWeb, :controller

  defp auth_url,
    do: Application.get_env(:sertantai_hub, :auth_service_url, "http://localhost:4000")

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
    proxy_post(conn, "/api/auth/refresh", params, auth_header(conn))
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

  defp proxy_get(conn, path, headers) do
    url = auth_url() <> path

    req_headers =
      [{"content-type", "application/json"}] ++ headers

    case Req.get(url, headers: req_headers, receive_timeout: 10_000) do
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

    case Req.post(url, json: body, headers: req_headers, receive_timeout: 10_000) do
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
