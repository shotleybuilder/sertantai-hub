defmodule SertantaiHub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SertantaiHubWeb.Telemetry,
      SertantaiHub.Repo,
      {DNSCluster, query: Application.get_env(:sertantai_hub, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SertantaiHub.PubSub},
      # JWKS client — fetches EdDSA public key from sertantai-auth for JWT verification
      # In test mode, skips HTTP fetch — tests call set_test_key/1 instead
      SertantaiHub.Auth.JwksClient,
      # Start to serve requests, typically the last entry
      SertantaiHubWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SertantaiHub.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SertantaiHubWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
