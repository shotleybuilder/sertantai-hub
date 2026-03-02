defmodule SertantaiHub.Repo.Migrations.AlignSnapshotsAfterAuthRepoRefactor do
  @moduledoc """
  Aligns Ash snapshots after the AuthRepo refactor.

  FK constraints to users/organizations were already dropped by
  20260302150000_remove_auth_shadow_tables.exs. This migration
  only adds indexes on the now-unconstrained UUID columns.
  """

  use Ecto.Migration

  def up do
    create(index(:law_change_subscriptions, [:organization_id]))
    create(index(:law_change_subscriptions, [:user_id]))
    create(index(:law_change_events, [:organization_id]))
  end

  def down do
    drop_if_exists(index(:law_change_events, [:organization_id]))
    drop_if_exists(index(:law_change_subscriptions, [:user_id]))
    drop_if_exists(index(:law_change_subscriptions, [:organization_id]))
  end
end
