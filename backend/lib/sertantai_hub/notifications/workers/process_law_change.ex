defmodule SertantaiHub.Notifications.Workers.ProcessLawChange do
  @moduledoc """
  Oban worker that processes a single law change from sertantai-legal.

  For each incoming change, finds all matching enabled subscriptions,
  creates LawChangeEvent records, and enqueues notification delivery
  for immediate-frequency subscriptions.
  """

  use Oban.Worker, queue: :notifications

  alias SertantaiHub.Notifications.{LawChangeEvent, Matcher}

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"change" => change, "batch_id" => batch_id}}) do
    matching_subscriptions = Matcher.find_matching_subscriptions(change)

    Enum.each(matching_subscriptions, fn subscription ->
      {:ok, event} = create_event(subscription, change, batch_id)

      if subscription.frequency == :immediate do
        %{"event_id" => event.id, "subscription_id" => subscription.id}
        |> SertantaiHub.Notifications.Workers.DeliverNotification.new()
        |> Oban.insert()
      end
    end)

    :ok
  end

  defp create_event(subscription, change, batch_id) do
    LawChangeEvent
    |> Ash.Changeset.for_create(:create, %{
      organization_id: subscription.organization_id,
      subscription_id: subscription.id,
      law_name: Map.get(change, "law_name", ""),
      law_title: Map.get(change, "law_title", ""),
      change_type: Map.get(change, "change_type", ""),
      families: Map.get(change, "families", []),
      summary: build_summary(change),
      source_metadata: change,
      batch_id: batch_id
    })
    |> Ash.create()
  end

  defp build_summary(change) do
    type = Map.get(change, "change_type", "changed")
    title = Map.get(change, "law_title", "Unknown")
    "#{String.capitalize(type)}: #{title}"
  end
end
