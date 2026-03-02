defmodule SertantaiHub.Repo.Migrations.RemoveAuthShadowTables do
  @moduledoc """
  Remove hub's shadow copies of users and organizations tables.

  Hub now reads these directly from the auth database via AuthRepo.
  The organization_id and user_id columns remain on domain tables
  but are no longer FK-constrained (cross-database FKs aren't possible).
  """

  use Ecto.Migration

  def up do
    # Drop FK constraints from domain tables
    drop(constraint(:law_change_subscriptions, "law_change_subscriptions_organization_id_fkey"))
    drop(constraint(:law_change_subscriptions, "law_change_subscriptions_user_id_fkey"))
    drop(constraint(:law_change_events, "law_change_events_organization_id_fkey"))

    # Drop FK from users -> organizations (in hub DB)
    drop(constraint(:users, "users_organization_id_fkey"))

    # Drop the shadow tables (they were always empty)
    drop(table(:users))
    drop(table(:organizations))
  end

  def down do
    create table(:organizations, primary_key: false) do
      add(:id, :uuid, null: false, primary_key: true, default: fragment("gen_random_uuid()"))
      add(:name, :text, null: false)
      add(:slug, :text, null: false)
      add(:tier, :text, null: false, default: "free")

      add(:inserted_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")
      )

      add(:updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")
      )
    end

    create table(:users, primary_key: false) do
      add(:id, :uuid, null: false, primary_key: true, default: fragment("gen_random_uuid()"))
      add(:email, :text, null: false)
      add(:name, :text)
      add(:organization_id, references(:organizations, type: :uuid), null: false)

      add(:inserted_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")
      )

      add(:updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")
      )
    end

    # Re-add FK constraints on domain tables
    alter table(:law_change_subscriptions) do
      modify(
        :organization_id,
        references(:organizations,
          column: :id,
          type: :uuid,
          name: "law_change_subscriptions_organization_id_fkey"
        ),
        from: :uuid
      )

      modify(
        :user_id,
        references(:users,
          column: :id,
          type: :uuid,
          name: "law_change_subscriptions_user_id_fkey"
        ),
        from: :uuid
      )
    end

    alter table(:law_change_events) do
      modify(
        :organization_id,
        references(:organizations,
          column: :id,
          type: :uuid,
          name: "law_change_events_organization_id_fkey"
        ),
        from: :uuid
      )
    end
  end
end
