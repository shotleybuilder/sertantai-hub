defmodule SertantaiHub.Notifications.LawChangeSubscription do
  @moduledoc """
  A user's subscription to law change notifications.

  Each subscription defines filter criteria (law families, geographic extent,
  change types, keywords, legislation type codes) that are matched against
  incoming law changes from sertantai-legal. When a change matches, a
  LawChangeEvent is created and delivered per the subscription's frequency
  and delivery method settings.
  """

  use Ash.Resource,
    domain: SertantaiHub.Notifications,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("law_change_subscriptions")
    repo(SertantaiHub.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :organization_id, :uuid do
      allow_nil?(false)
    end

    attribute(:user_id, :uuid)

    attribute :name, :string do
      allow_nil?(false)
    end

    attribute :law_families, {:array, :string} do
      default([])
    end

    attribute :geo_extent, {:array, :string} do
      default([])
    end

    attribute :change_types, {:array, :string} do
      default([])
    end

    attribute :keywords, {:array, :string} do
      default([])
    end

    attribute :type_codes, {:array, :string} do
      default([])
    end

    attribute :frequency, :atom do
      constraints(one_of: [:immediate, :daily_digest, :weekly_digest])
      default(:daily_digest)
      allow_nil?(false)
    end

    attribute :delivery_methods, {:array, :string} do
      default(["email"])
    end

    attribute :enabled, :boolean do
      default(true)
      allow_nil?(false)
    end

    create_timestamp(:inserted_at)
    update_timestamp(:updated_at)
  end

  relationships do
    belongs_to :organization, SertantaiHub.Auth.Organization do
      define_attribute?(false)
      source_attribute(:organization_id)
    end

    belongs_to :user, SertantaiHub.Auth.User do
      define_attribute?(false)
      source_attribute(:user_id)
      allow_nil?(true)
    end

    has_many :events, SertantaiHub.Notifications.LawChangeEvent do
      destination_attribute(:subscription_id)
    end
  end

  actions do
    defaults([:read, :destroy])

    create :create do
      accept([
        :organization_id,
        :user_id,
        :name,
        :law_families,
        :geo_extent,
        :change_types,
        :keywords,
        :type_codes,
        :frequency,
        :delivery_methods,
        :enabled
      ])

      change(SertantaiHub.Notifications.Changes.ValidateTierLimits)
    end

    update :update do
      require_atomic?(false)

      accept([
        :name,
        :law_families,
        :geo_extent,
        :change_types,
        :keywords,
        :type_codes,
        :frequency,
        :delivery_methods,
        :enabled
      ])

      change(SertantaiHub.Notifications.Changes.ValidateTierLimits)
    end

    read :by_organization do
      argument(:organization_id, :uuid, allow_nil?: false)
      filter(expr(organization_id == ^arg(:organization_id)))
    end

    read :by_user do
      argument(:user_id, :uuid, allow_nil?: false)
      filter(expr(user_id == ^arg(:user_id)))
    end

    read :enabled_for_matching do
      filter(expr(enabled == true))
    end
  end

  code_interface do
    define(:read)
    define(:create)
    define(:update)
    define(:destroy)
    define(:by_organization, args: [:organization_id])
    define(:by_user, args: [:user_id])
    define(:enabled_for_matching)
  end
end
