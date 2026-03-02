defmodule SertantaiHub.Auth.Organization do
  @moduledoc """
  Organization resource — reads from the sertantai-auth database.
  Hub is a read-only consumer; auth service owns the schema.
  """
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    domain: SertantaiHub.Api

  postgres do
    table("organizations")
    repo(SertantaiHub.AuthRepo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :name, :string do
      allow_nil?(false)
    end

    attribute :slug, :string do
      allow_nil?(false)
    end

    attribute :tier, :atom do
      constraints(one_of: [:free, :standard, :premium])
      default(:free)
      allow_nil?(false)
    end

    attribute(:domain, :string)

    attribute :settings, :map do
      default(%{})
    end

    create_timestamp(:inserted_at)
    update_timestamp(:updated_at)
  end

  relationships do
    has_many(:users, SertantaiHub.Auth.User)
  end

  actions do
    defaults([:read])

    read :by_id do
      argument(:id, :uuid, allow_nil?: false)
      get?(true)
      filter(expr(id == ^arg(:id)))
    end

    read :by_slug do
      argument(:slug, :string, allow_nil?: false)
      get?(true)
      filter(expr(slug == ^arg(:slug)))
    end
  end

  code_interface do
    define(:read)
    define(:by_id, args: [:id])
    define(:by_slug, args: [:slug])
  end
end
