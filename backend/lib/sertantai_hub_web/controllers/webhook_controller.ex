defmodule SertantaiHubWeb.WebhookController do
  @moduledoc """
  Receives law change webhooks from sertantai-legal.

  Validates the payload and enqueues an Oban job per change for
  asynchronous subscription matching and notification delivery.
  """

  use SertantaiHubWeb, :controller

  def law_change(conn, %{"changes" => changes, "batch_id" => batch_id, "timestamp" => _timestamp})
      when is_list(changes) do
    jobs =
      Enum.map(changes, fn change ->
        SertantaiHub.Notifications.Workers.ProcessLawChange.new(%{
          "change" => change,
          "batch_id" => batch_id
        })
      end)

    Oban.insert_all(jobs)

    conn
    |> put_status(202)
    |> json(%{status: "accepted", changes_queued: length(changes)})
  end

  def law_change(conn, _params) do
    conn
    |> put_status(400)
    |> json(%{
      error: "Invalid payload. Expected: {changes: [...], batch_id: string, timestamp: string}"
    })
  end
end
