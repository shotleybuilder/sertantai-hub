# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :sertantai_hub,
  ecto_repos: [SertantaiHub.Repo],
  ash_domains: [SertantaiHub.Api, SertantaiHub.Notifications],
  generators: [timestamp_type: :utc_datetime],
  auth_service_url: "http://localhost:4000",
  auth_url: "http://localhost:4000",
  webhook_api_key: "dev-webhook-key-change-me"

# Oban background job processing
config :sertantai_hub, Oban,
  repo: SertantaiHub.Repo,
  queues: [notifications: 10, digests: 5],
  plugins: [
    {Oban.Plugins.Cron,
     crontab: [
       {"0 8 * * *", SertantaiHub.Notifications.Workers.DailyDigest}
     ]}
  ]

# Swoosh mailer
config :sertantai_hub, SertantaiHub.Mailer, adapter: Swoosh.Adapters.Local

# Disable Swoosh API client (we use SMTP/local adapters, not API-based ones)
config :swoosh, :api_client, false

# Configures the endpoint
config :sertantai_hub, SertantaiHubWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: SertantaiHubWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: SertantaiHub.PubSub,
  live_view: [signing_salt: "xjXQzhFq"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
