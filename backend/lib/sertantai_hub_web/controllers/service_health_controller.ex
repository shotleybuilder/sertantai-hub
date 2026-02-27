defmodule SertantaiHubWeb.ServiceHealthController do
  @moduledoc """
  Proxies health checks for known micro-services.

  The frontend calls this endpoint (same origin) instead of
  calling service health URLs directly (which would be blocked by CORS).
  Only a fixed allowlist of service names is accepted.
  """

  use SertantaiHubWeb, :controller

  @services %{
    "legal" => {:legal_url, "http://localhost:4003"},
    "enforcement" => {:enforcement_url, "http://localhost:4001"},
    "controls" => {:controls_url, "http://localhost:4004"}
  }

  def show(conn, %{"service" => service}) do
    case Map.get(@services, service) do
      nil ->
        conn
        |> put_status(404)
        |> json(%{status: "error", message: "Unknown service"})

      {config_key, default} ->
        url = Application.get_env(:sertantai_hub, config_key, default)
        check_health(conn, url)
    end
  end

  defp check_health(conn, base_url) do
    case Req.get("#{base_url}/health",
           receive_timeout: 3_000,
           retry: false,
           redirect: false
         ) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        conn |> put_status(200) |> json(body)

      {:ok, %Req.Response{status: status}} when status in [301, 302] ->
        # Service is running but has force_ssl enabled, which redirects HTTP → HTTPS.
        # A redirect proves the app is alive and responding.
        conn |> put_status(200) |> json(%{status: "ok"})

      {:ok, %Req.Response{status: status}} ->
        conn |> put_status(200) |> json(%{status: "unhealthy", code: status})

      {:error, _reason} ->
        conn |> put_status(200) |> json(%{status: "offline"})
    end
  end
end
