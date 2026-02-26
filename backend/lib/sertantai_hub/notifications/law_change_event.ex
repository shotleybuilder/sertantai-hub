defmodule SertantaiHub.Notifications.LawChangeEvent do
  @moduledoc """
  A record of a law change that matched a user's subscription.

  Created when an incoming law change from sertantai-legal matches a
  LawChangeSubscription's filter criteria. Used for audit, display,
  and tracking delivery status.
  """

  use Ash.Resource,
    domain: SertantaiHub.Notifications,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("law_change_events")
    repo(SertantaiHub.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :organization_id, :uuid do
      allow_nil?(false)
    end

    attribute :subscription_id, :uuid do
      allow_nil?(false)
    end

    attribute :law_name, :string do
      allow_nil?(false)
    end

    attribute :law_title, :string do
      allow_nil?(false)
    end

    attribute :change_type, :string do
      allow_nil?(false)
    end

    attribute :families, {:array, :string} do
      default([])
    end

    attribute(:summary, :string)

    attribute(:source_metadata, :map)

    attribute(:delivered_at, :utc_datetime)

    attribute(:batch_id, :string)

    create_timestamp(:inserted_at)
  end

  relationships do
    belongs_to :organization, SertantaiHub.Auth.Organization do
      define_attribute?(false)
      source_attribute(:organization_id)
    end

    belongs_to :subscription, SertantaiHub.Notifications.LawChangeSubscription do
      define_attribute?(false)
      source_attribute(:subscription_id)
    end
  end

  actions do
    defaults([:read])

    create :create do
      accept([
        :organization_id,
        :subscription_id,
        :law_name,
        :law_title,
        :change_type,
        :families,
        :summary,
        :source_metadata,
        :batch_id
      ])
    end

    update :mark_delivered do
      accept([])

      change(set_attribute(:delivered_at, &DateTime.utc_now/0))
    end

    read :by_organization do
      argument(:organization_id, :uuid, allow_nil?: false)
      filter(expr(organization_id == ^arg(:organization_id)))
    end

    read :by_subscription do
      argument(:subscription_id, :uuid, allow_nil?: false)
      filter(expr(subscription_id == ^arg(:subscription_id)))
    end

    read :pending_digest do
      filter(expr(is_nil(delivered_at)))
    end
  end

  code_interface do
    define(:read)
    define(:create)
    define(:mark_delivered)
    define(:by_organization, args: [:organization_id])
    define(:by_subscription, args: [:subscription_id])
    define(:pending_digest)
  end
end
