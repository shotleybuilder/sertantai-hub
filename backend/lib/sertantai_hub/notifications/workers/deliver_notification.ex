defmodule SertantaiHub.Notifications.Workers.DeliverNotification do
  @moduledoc """
  Oban worker that delivers a single immediate notification email.

  Looks up the event, the subscription's user, builds the email, sends it,
  and marks the event as delivered.
  """

  use Oban.Worker, queue: :notifications

  alias SertantaiHub.Auth.User
  alias SertantaiHub.Notifications.{Emails, LawChangeEvent, LawChangeSubscription}

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"event_id" => event_id, "subscription_id" => subscription_id}}) do
    with {:ok, event} <- LawChangeEvent |> Ash.get(event_id),
         {:ok, subscription} <- LawChangeSubscription |> Ash.get(subscription_id),
         {:ok, user} <- get_subscriber(subscription),
         {:ok, _email} <- deliver_email(user.email, event),
         {:ok, _event} <- mark_delivered(event) do
      :ok
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp get_subscriber(%{user_id: nil}), do: {:error, :no_user}

  defp get_subscriber(%{user_id: user_id}) do
    User |> Ash.get(user_id)
  end

  defp deliver_email(email, event) do
    email
    |> Emails.immediate(event)
    |> SertantaiHub.Mailer.deliver()
  end

  defp mark_delivered(event) do
    event
    |> Ash.Changeset.for_update(:mark_delivered, %{})
    |> Ash.update()
  end
end
