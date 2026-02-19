defmodule SertantaiHubWeb.Router do
  use SertantaiHubWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  # Health check endpoints (no /api prefix, no authentication required)
  scope "/", SertantaiHubWeb do
    pipe_through(:api)
    get("/health", HealthController, :index)
    get("/health/detailed", HealthController, :show)
  end

  # API endpoints
  scope "/api", SertantaiHubWeb do
    pipe_through(:api)
    get("/hello", HelloController, :index)
  end

  # Auth proxy — forwards to sertantai-auth service
  scope "/api/auth", SertantaiHubWeb do
    pipe_through(:api)
    post("/register", AuthProxyController, :register)
    post("/login", AuthProxyController, :sign_in)
    post("/logout", AuthProxyController, :sign_out)
    post("/refresh", AuthProxyController, :refresh)
  end
end
