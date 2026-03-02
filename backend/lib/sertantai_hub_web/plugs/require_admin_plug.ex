defmodule SertantaiHubWeb.RequireAdminPlug do
  @moduledoc """
  Plug that requires the authenticated user to have an admin role (owner or admin).

  Must be used after `AuthPlug`, which sets `conn.assigns.user_role`.
  Returns 403 Forbidden if the user's role is not owner or admin.
  """

  import Plug.Conn

  @behaviour Plug

  @admin_roles ~w(owner admin)

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    if conn.assigns[:user_role] in @admin_roles do
      conn
    else
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(403, Jason.encode!(%{error: "Forbidden", message: "Admin access required"}))
      |> halt()
    end
  end
end
