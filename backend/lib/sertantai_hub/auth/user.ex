defmodule SertantaiHub.Auth.User do
  @moduledoc """
  User resource — reads from the sertantai-auth database.
  Hub is a read-only consumer; auth service owns the schema.
  """
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    domain: SertantaiHub.Api

  postgres do
    table("users")
    repo(SertantaiHub.AuthRepo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :email, :ci_string do
      allow_nil?(false)
    end

    attribute(:name, :string)

    attribute(:organization_id, :uuid)

    attribute :role, :atom do
      constraints(one_of: [:owner, :admin, :member, :viewer])
      default(:viewer)
      allow_nil?(false)
    end

    attribute(:killed_at, :utc_datetime_usec)
    attribute(:github_login, :string)
    attribute(:avatar_url, :string)

    create_timestamp(:inserted_at)
    update_timestamp(:updated_at)
  end

  relationships do
    belongs_to(:organization, SertantaiHub.Auth.Organization)
  end

  actions do
    defaults([:read])

    read :by_id do
      argument(:id, :uuid, allow_nil?: false)
      get?(true)
      filter(expr(id == ^arg(:id)))
    end

    read :by_organization do
      argument(:organization_id, :uuid, allow_nil?: false)
      filter(expr(organization_id == ^arg(:organization_id)))
    end
  end

  code_interface do
    define(:read)
    define(:by_id, args: [:id])
    define(:by_organization, args: [:organization_id])
  end
end
