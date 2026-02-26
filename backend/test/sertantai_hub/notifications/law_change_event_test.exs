defmodule SertantaiHub.Notifications.LawChangeEventTest do
  use SertantaiHub.DataCase, async: true

  alias SertantaiHub.Notifications.LawChangeEvent

  import SertantaiHub.NotificationHelpers

  setup do
    create_test_org()
    create_test_user()
    sub = create_test_subscription(%{name: "Test Sub"})
    %{subscription: sub}
  end

  describe "create" do
    test "creates an event with valid data", %{subscription: sub} do
      {:ok, event} =
        LawChangeEvent
        |> Ash.Changeset.for_create(:create, %{
          organization_id: default_org_id(),
          subscription_id: sub.id,
          law_name: "ukpga/2025/42",
          law_title: "Climate Change Act 2025",
          change_type: "new",
          families: ["E:CLIMATE"],
          summary: "New: Climate Change Act 2025",
          batch_id: "scrape-2025-03-15"
        })
        |> Ash.create()

      assert event.law_name == "ukpga/2025/42"
      assert event.law_title == "Climate Change Act 2025"
      assert event.change_type == "new"
      assert event.families == ["E:CLIMATE"]
      assert is_nil(event.delivered_at)
    end
  end

  describe "mark_delivered" do
    test "sets delivered_at timestamp", %{subscription: sub} do
      {:ok, event} =
        LawChangeEvent
        |> Ash.Changeset.for_create(:create, %{
          organization_id: default_org_id(),
          subscription_id: sub.id,
          law_name: "ukpga/2025/1",
          law_title: "Test Act",
          change_type: "new"
        })
        |> Ash.create()

      assert is_nil(event.delivered_at)

      {:ok, delivered} =
        event
        |> Ash.Changeset.for_update(:mark_delivered, %{})
        |> Ash.update()

      refute is_nil(delivered.delivered_at)
    end
  end

  describe "pending_digest" do
    test "returns only undelivered events", %{subscription: sub} do
      {:ok, _pending} =
        LawChangeEvent
        |> Ash.Changeset.for_create(:create, %{
          organization_id: default_org_id(),
          subscription_id: sub.id,
          law_name: "ukpga/2025/1",
          law_title: "Pending Event",
          change_type: "new"
        })
        |> Ash.create()

      {:ok, delivered} =
        LawChangeEvent
        |> Ash.Changeset.for_create(:create, %{
          organization_id: default_org_id(),
          subscription_id: sub.id,
          law_name: "ukpga/2025/2",
          law_title: "Delivered Event",
          change_type: "amended"
        })
        |> Ash.create()

      delivered
      |> Ash.Changeset.for_update(:mark_delivered, %{})
      |> Ash.update!()

      {:ok, pending} = LawChangeEvent.pending_digest()
      assert length(pending) == 1
      assert hd(pending).law_title == "Pending Event"
    end
  end

  describe "by_organization" do
    test "returns events for the given org", %{subscription: sub} do
      {:ok, _event} =
        LawChangeEvent
        |> Ash.Changeset.for_create(:create, %{
          organization_id: default_org_id(),
          subscription_id: sub.id,
          law_name: "ukpga/2025/1",
          law_title: "Test",
          change_type: "new"
        })
        |> Ash.create()

      {:ok, events} = LawChangeEvent.by_organization(default_org_id())
      assert length(events) == 1
    end
  end
end
