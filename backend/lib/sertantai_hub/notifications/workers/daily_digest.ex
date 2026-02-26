defmodule SertantaiHub.Notifications.Workers.DailyDigest do
  @moduledoc """
  Oban cron worker that sends daily digest emails.

  Runs at 8am UTC daily. Collects pending (undelivered) law change events
  for daily_digest subscriptions, groups them by user, builds digest emails,
  and marks events as delivered.
  """

  use Oban.Worker, queue: :digests

  alias SertantaiHub.Auth.User
  alias SertantaiHub.Notifications.{Emails, LawChangeEvent, LawChangeSubscription}

  @impl Oban.Worker
  def perform(_job) do
    with {:ok, pending_events} <- LawChangeEvent.pending_digest(),
         grouped <- group_events_by_user(pending_events) do
      Enum.each(grouped, fn {user_id, events} ->
        deliver_digest(user_id, events)
      end)

      :ok
    end
  end

  defp group_events_by_user(events) do
    # Load subscription for each event to get user_id, then group
    events
    |> Enum.reduce(%{}, fn event, acc ->
      case LawChangeSubscription |> Ash.get(event.subscription_id) do
        {:ok, %{user_id: user_id, frequency: :daily_digest}} when not is_nil(user_id) ->
          Map.update(acc, user_id, [event], &[event | &1])

        _ ->
          acc
      end
    end)
  end

  defp deliver_digest(user_id, events) do
    with {:ok, user} <- User |> Ash.get(user_id) do
      case Emails.digest(user.email, events) |> SertantaiHub.Mailer.deliver() do
        {:ok, _} ->
          Enum.each(events, fn event ->
            event
            |> Ash.Changeset.for_update(:mark_delivered, %{})
            |> Ash.update()
          end)

        {:error, _reason} ->
          :ok
      end
    end
  end
end
