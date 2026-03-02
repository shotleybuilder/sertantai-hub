defmodule SertantaiHub.AuthRepo.Migrations.AlignSnapshotsAfterAuthRepoRefactor do
  @moduledoc """
  No-op migration to establish Ash snapshot baseline for AuthRepo.

  Hub reads the auth database in read-only mode. The users and
  organizations tables are owned and migrated by sertantai-auth.
  This migration exists only so Ash's snapshot tracking is aligned.
  """

  use Ecto.Migration

  def up, do: :ok
  def down, do: :ok
end
