defmodule SertantaiHub.Repo.Migrations.EnableUserOrgElectricSync do
  @moduledoc """
  Enable ElectricSQL sync for users and organizations tables.

  Sets REPLICA IDENTITY FULL so ElectricSQL can track all column changes
  for real-time sync to the admin dashboard.
  """

  use Ecto.Migration

  def up do
    execute("ALTER TABLE users REPLICA IDENTITY FULL")
    execute("ALTER TABLE organizations REPLICA IDENTITY FULL")
  end

  def down do
    execute("ALTER TABLE users REPLICA IDENTITY DEFAULT")
    execute("ALTER TABLE organizations REPLICA IDENTITY DEFAULT")
  end
end
