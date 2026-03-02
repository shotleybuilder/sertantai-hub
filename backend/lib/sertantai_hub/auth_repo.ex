defmodule SertantaiHub.AuthRepo do
  @moduledoc """
  Read-only Ecto repository for the sertantai-auth database.

  Hub reads user and organization data directly from the auth service's database.
  This repo never runs migrations — the auth service owns the schema.
  """

  use AshPostgres.Repo,
    otp_app: :sertantai_hub,
    warn_on_missing_ash_functions?: false

  def installed_extensions do
    ["uuid-ossp", "citext"]
  end

  def min_pg_version do
    %Version{major: 15, minor: 0, patch: 0}
  end

  # Hub never migrates the auth database
  def migrations_paths, do: []
end
