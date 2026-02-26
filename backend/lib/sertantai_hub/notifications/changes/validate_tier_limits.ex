defmodule SertantaiHub.Notifications.Changes.ValidateTierLimits do
  @moduledoc """
  Ash change that enforces subscription tier limits.

  Validates that creating or updating a subscription doesn't exceed the
  organization's tier limits for subscription count, frequency, and
  delivery methods.
  """

  use Ash.Resource.Change

  alias SertantaiHub.Auth.Organization
  alias SertantaiHub.Notifications.LawChangeSubscription

  @tier_limits %{
    blanket_bog: %{
      max_subscriptions: 3,
      frequencies: [:daily_digest],
      delivery_methods: ["email"]
    },
    heathland: %{
      max_subscriptions: 10,
      frequencies: [:immediate, :daily_digest, :weekly_digest],
      delivery_methods: ["email", "in_app"]
    },
    ancient_woodland: %{
      max_subscriptions: :unlimited,
      frequencies: [:immediate, :daily_digest, :weekly_digest],
      delivery_methods: ["email", "in_app", "webhook"]
    }
  }

  @impl true
  def change(changeset, _opts, _context) do
    changeset
    |> validate_subscription_count()
    |> validate_frequency()
    |> validate_delivery_methods()
  end

  defp validate_subscription_count(changeset) do
    # Only check count on create (not update)
    if changeset.action.type != :create do
      changeset
    else
      org_id = Ash.Changeset.get_attribute(changeset, :organization_id)

      case get_tier(org_id) do
        {:ok, tier} ->
          limits = Map.get(@tier_limits, tier, @tier_limits.blanket_bog)

          if limits.max_subscriptions == :unlimited do
            changeset
          else
            case LawChangeSubscription.by_organization(org_id) do
              {:ok, existing} when length(existing) >= limits.max_subscriptions ->
                Ash.Changeset.add_error(changeset,
                  field: :organization_id,
                  message:
                    "subscription limit reached (#{limits.max_subscriptions} for #{tier} tier)"
                )

              _ ->
                changeset
            end
          end

        {:error, _} ->
          changeset
      end
    end
  end

  defp validate_frequency(changeset) do
    frequency = Ash.Changeset.get_attribute(changeset, :frequency)
    org_id = Ash.Changeset.get_attribute(changeset, :organization_id)

    if is_nil(frequency) do
      changeset
    else
      case get_tier(org_id) do
        {:ok, tier} ->
          limits = Map.get(@tier_limits, tier, @tier_limits.blanket_bog)

          if frequency in limits.frequencies do
            changeset
          else
            Ash.Changeset.add_error(changeset,
              field: :frequency,
              message: "#{frequency} is not available on the #{tier} tier"
            )
          end

        {:error, _} ->
          changeset
      end
    end
  end

  defp validate_delivery_methods(changeset) do
    methods = Ash.Changeset.get_attribute(changeset, :delivery_methods)
    org_id = Ash.Changeset.get_attribute(changeset, :organization_id)

    if is_nil(methods) || methods == [] do
      changeset
    else
      case get_tier(org_id) do
        {:ok, tier} ->
          limits = Map.get(@tier_limits, tier, @tier_limits.blanket_bog)
          invalid = methods -- limits.delivery_methods

          if invalid == [] do
            changeset
          else
            Ash.Changeset.add_error(changeset,
              field: :delivery_methods,
              message: "#{Enum.join(invalid, ", ")} not available on the #{tier} tier"
            )
          end

        {:error, _} ->
          changeset
      end
    end
  end

  defp get_tier(nil), do: {:error, :no_org}

  defp get_tier(org_id) do
    case Organization.by_id(org_id) do
      {:ok, org} -> {:ok, org.tier}
      error -> error
    end
  end
end
