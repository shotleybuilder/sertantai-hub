defmodule SertantaiHubWeb.NotificationEventController do
  @moduledoc """
  Lists law change events for the authenticated user's subscriptions.
  """

  use SertantaiHubWeb, :controller

  alias SertantaiHub.Notifications.LawChangeEvent

  def index(conn, _params) do
    organization_id = conn.assigns.organization_id

    case LawChangeEvent.by_organization(organization_id) do
      {:ok, events} ->
        json(conn, %{data: Enum.map(events, &serialize/1)})

      {:error, reason} ->
        conn |> put_status(500) |> json(%{error: inspect(reason)})
    end
  end

  defp serialize(event) do
    %{
      id: event.id,
      organization_id: event.organization_id,
      subscription_id: event.subscription_id,
      law_name: event.law_name,
      law_title: event.law_title,
      change_type: event.change_type,
      families: event.families,
      summary: event.summary,
      delivered_at: event.delivered_at,
      batch_id: event.batch_id,
      inserted_at: event.inserted_at
    }
  end
end
