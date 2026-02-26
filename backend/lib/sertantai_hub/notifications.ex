defmodule SertantaiHub.Notifications do
  @moduledoc """
  Ash Domain for law change notification subscriptions.

  Manages user subscriptions to UK legislation changes and
  the events generated when changes match subscription filters.
  """

  use Ash.Domain

  resources do
    resource(SertantaiHub.Notifications.LawChangeSubscription)
    resource(SertantaiHub.Notifications.LawChangeEvent)
  end
end
