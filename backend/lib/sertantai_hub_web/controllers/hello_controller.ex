defmodule SertantaiHubWeb.HelloController do
  use SertantaiHubWeb, :controller

  @doc """
  Simple hello endpoint to test API connectivity.
  Returns a friendly greeting message.
  """
  def index(conn, _params) do
    json(conn, %{
      message: "Hello from Sertantai Controls API!",
      environment: Application.get_env(:sertantai_hub, :environment, :dev),
      timestamp: DateTime.utc_now() |> DateTime.to_iso8601()
    })
  end
end
