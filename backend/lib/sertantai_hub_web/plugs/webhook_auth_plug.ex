defmodule SertantaiHubWeb.WebhookAuthPlug do
  @moduledoc """
  Validates webhook requests using an API key in the `x-api-key` header.

  Used to authenticate incoming webhooks from trusted services like
  sertantai-legal. The expected key is configured via the `:webhook_api_key`
  application config (set via `WEBHOOK_API_KEY` env var in production).
  """

  import Plug.Conn

  @behaviour Plug

  @impl Plug
  def init(opts), do: opts

  @impl Plug
  def call(conn, _opts) do
    expected_key = Application.get_env(:sertantai_hub, :webhook_api_key)

    case get_req_header(conn, "x-api-key") do
      [^expected_key] when is_binary(expected_key) ->
        conn

      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(401, Jason.encode!(%{error: "Invalid or missing API key"}))
        |> halt()
    end
  end
end
