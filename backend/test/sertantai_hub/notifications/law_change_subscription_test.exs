defmodule SertantaiHub.Notifications.LawChangeSubscriptionTest do
  use SertantaiHub.DataCase, async: true

  alias SertantaiHub.Notifications.LawChangeSubscription

  import SertantaiHub.NotificationHelpers

  setup do
    create_test_org()
    create_test_user()
    :ok
  end

  describe "create" do
    test "creates a subscription with valid data" do
      sub = create_test_subscription(%{name: "Scottish Climate Laws"})

      assert sub.name == "Scottish Climate Laws"
      assert sub.organization_id == default_org_id()
      assert sub.user_id == default_user_id()
      assert sub.frequency == :daily_digest
      assert sub.delivery_methods == ["email"]
      assert sub.enabled == true
    end

    test "creates subscription with filter arrays" do
      sub =
        create_test_subscription(%{
          name: "Filtered Sub",
          law_families: ["E:CLIMATE", "E:ENVIRONMENT"],
          geo_extent: ["S"],
          change_types: ["new", "amended"],
          keywords: ["climate"],
          type_codes: ["asp"]
        })

      assert sub.law_families == ["E:CLIMATE", "E:ENVIRONMENT"]
      assert sub.geo_extent == ["S"]
      assert sub.change_types == ["new", "amended"]
      assert sub.keywords == ["climate"]
      assert sub.type_codes == ["asp"]
    end

    test "requires name" do
      assert {:error, _} =
               LawChangeSubscription
               |> Ash.Changeset.for_create(:create, %{
                 organization_id: default_org_id(),
                 user_id: default_user_id()
               })
               |> Ash.create()
    end

    test "requires organization_id" do
      assert {:error, _} =
               LawChangeSubscription
               |> Ash.Changeset.for_create(:create, %{
                 name: "No Org",
                 user_id: default_user_id()
               })
               |> Ash.create()
    end
  end

  describe "by_organization" do
    test "returns subscriptions for the given org" do
      create_test_subscription(%{name: "Sub 1"})
      create_test_subscription(%{name: "Sub 2"})

      {:ok, subs} = LawChangeSubscription.by_organization(default_org_id())
      assert length(subs) == 2
    end

    test "does not return subscriptions from other orgs" do
      other_org_id = "00000000-0000-0000-0000-000000000099"
      create_test_org(id: other_org_id, name: "Other Org", slug: "other-org")
      create_test_subscription(%{name: "My Sub"})

      {:ok, subs} = LawChangeSubscription.by_organization(other_org_id)
      assert subs == []
    end
  end

  describe "enabled_for_matching" do
    test "returns only enabled subscriptions" do
      create_test_subscription(%{name: "Enabled", enabled: true})
      create_test_subscription(%{name: "Disabled", enabled: false})

      {:ok, subs} = LawChangeSubscription.enabled_for_matching()
      assert length(subs) == 1
      assert hd(subs).name == "Enabled"
    end
  end

  describe "update" do
    test "updates mutable fields" do
      sub = create_test_subscription(%{name: "Original"})

      {:ok, updated} =
        sub
        |> Ash.Changeset.for_update(:update, %{name: "Updated", enabled: false})
        |> Ash.update()

      assert updated.name == "Updated"
      assert updated.enabled == false
    end
  end

  describe "destroy" do
    test "deletes a subscription" do
      sub = create_test_subscription(%{name: "To Delete"})

      assert :ok = Ash.destroy(sub)
      {:ok, subs} = LawChangeSubscription.by_organization(default_org_id())
      assert subs == []
    end
  end

  describe "tier limits" do
    test "blanket_bog tier allows max 3 subscriptions" do
      create_test_subscription(%{name: "Sub 1"})
      create_test_subscription(%{name: "Sub 2"})
      create_test_subscription(%{name: "Sub 3"})

      assert {:error, _} =
               LawChangeSubscription
               |> Ash.Changeset.for_create(:create, %{
                 organization_id: default_org_id(),
                 user_id: default_user_id(),
                 name: "Sub 4"
               })
               |> Ash.create()
    end

    test "blanket_bog tier rejects immediate frequency" do
      assert {:error, _} =
               LawChangeSubscription
               |> Ash.Changeset.for_create(:create, %{
                 organization_id: default_org_id(),
                 user_id: default_user_id(),
                 name: "Immediate Sub",
                 frequency: :immediate
               })
               |> Ash.create()
    end

    test "blanket_bog tier rejects in_app delivery" do
      assert {:error, _} =
               LawChangeSubscription
               |> Ash.Changeset.for_create(:create, %{
                 organization_id: default_org_id(),
                 user_id: default_user_id(),
                 name: "InApp Sub",
                 delivery_methods: ["email", "in_app"]
               })
               |> Ash.create()
    end

    test "heathland tier allows immediate frequency" do
      heathland_org_id = "00000000-0000-0000-0000-000000000088"
      heathland_user_id = "00000000-0000-0000-0000-000000000089"

      create_test_org(
        id: heathland_org_id,
        name: "Heathland Org",
        slug: "heathland-org",
        tier: "heathland"
      )

      create_test_user(
        id: heathland_user_id,
        email: "heathland@example.com",
        organization_id: heathland_org_id
      )

      assert {:ok, sub} =
               LawChangeSubscription
               |> Ash.Changeset.for_create(:create, %{
                 organization_id: heathland_org_id,
                 user_id: heathland_user_id,
                 name: "Immediate Sub",
                 frequency: :immediate
               })
               |> Ash.create()

      assert sub.frequency == :immediate
    end
  end
end
