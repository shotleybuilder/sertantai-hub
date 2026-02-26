defmodule SertantaiHub.NotificationHelpers do
  @moduledoc """
  Test helpers for creating notification-related test data.

  Since User and Organization are read-only Ash resources, we use
  direct SQL to insert test records.
  """

  alias SertantaiHub.Repo

  # Valid UUID v4 format IDs matching AuthHelpers defaults
  @default_org_id "00000000-0000-0000-0000-000000000001"
  @default_user_id "00000000-0000-0000-0000-000000000002"

  def default_org_id, do: @default_org_id
  def default_user_id, do: @default_user_id

  def create_test_org(opts \\ []) do
    id = Keyword.get(opts, :id, @default_org_id)
    name = Keyword.get(opts, :name, "Test Org")
    slug = Keyword.get(opts, :slug, "test-org")
    tier = Keyword.get(opts, :tier, "blanket_bog")

    Repo.query!(
      """
      INSERT INTO organizations (id, name, slug, tier, inserted_at, updated_at)
      VALUES ($1, $2, $3, $4, NOW(), NOW())
      ON CONFLICT (id) DO UPDATE SET tier = $4
      RETURNING id
      """,
      [dump_uuid!(id), name, slug, tier]
    )

    id
  end

  def create_test_user(opts \\ []) do
    id = Keyword.get(opts, :id, @default_user_id)
    email = Keyword.get(opts, :email, "test@example.com")
    name = Keyword.get(opts, :name, "Test User")
    org_id = Keyword.get(opts, :organization_id, @default_org_id)

    Repo.query!(
      """
      INSERT INTO users (id, email, name, organization_id, inserted_at, updated_at)
      VALUES ($1, $2, $3, $4, NOW(), NOW())
      ON CONFLICT (id) DO NOTHING
      RETURNING id
      """,
      [dump_uuid!(id), email, name, dump_uuid!(org_id)]
    )

    id
  end

  defp dump_uuid!(uuid_string) do
    {:ok, binary} = Ecto.UUID.dump(uuid_string)
    binary
  end

  def create_test_subscription(attrs \\ %{}) do
    defaults = %{
      organization_id: @default_org_id,
      user_id: @default_user_id,
      name: "Test Subscription",
      law_families: [],
      geo_extent: [],
      change_types: [],
      keywords: [],
      type_codes: [],
      frequency: :daily_digest,
      delivery_methods: ["email"],
      enabled: true
    }

    merged = Map.merge(defaults, attrs)

    SertantaiHub.Notifications.LawChangeSubscription
    |> Ash.Changeset.for_create(:create, merged)
    |> Ash.create!()
  end

  def sample_law_change(overrides \\ %{}) do
    defaults = %{
      "law_name" => "ukpga/2025/42",
      "law_title" => "Climate Change (Scotland) Act 2025",
      "change_type" => "new",
      "families" => ["E:CLIMATE"],
      "geo_extent" => "S",
      "type_code" => "asp",
      "year" => 2025,
      "metadata" => %{
        "source" => "legislation.gov.uk",
        "scraped_at" => "2025-03-15T10:30:00Z"
      }
    }

    Map.merge(defaults, overrides)
  end
end
