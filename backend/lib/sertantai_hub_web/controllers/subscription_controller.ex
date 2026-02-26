defmodule SertantaiHubWeb.SubscriptionController do
  @moduledoc """
  CRUD endpoints for law change notification subscriptions.

  All operations are scoped to the authenticated user's organization.
  """

  use SertantaiHubWeb, :controller

  alias SertantaiHub.Notifications.LawChangeSubscription

  def index(conn, _params) do
    user_id = conn.assigns.current_user_id

    case LawChangeSubscription.by_user(user_id) do
      {:ok, subscriptions} ->
        json(conn, %{data: Enum.map(subscriptions, &serialize/1)})

      {:error, reason} ->
        conn |> put_status(500) |> json(%{error: inspect(reason)})
    end
  end

  def show(conn, %{"id" => id}) do
    organization_id = conn.assigns.organization_id

    case LawChangeSubscription |> Ash.get(id) do
      {:ok, %{organization_id: ^organization_id} = subscription} ->
        json(conn, %{data: serialize(subscription)})

      {:ok, _} ->
        conn |> put_status(404) |> json(%{error: "Not found"})

      {:error, _} ->
        conn |> put_status(404) |> json(%{error: "Not found"})
    end
  end

  def create(conn, params) do
    attrs =
      params
      |> Map.take(
        ~w(name law_families geo_extent change_types keywords type_codes frequency delivery_methods enabled)
      )
      |> Map.put("organization_id", conn.assigns.organization_id)
      |> Map.put("user_id", conn.assigns.current_user_id)

    case LawChangeSubscription
         |> Ash.Changeset.for_create(:create, atomize_keys(attrs))
         |> Ash.create() do
      {:ok, subscription} ->
        conn |> put_status(201) |> json(%{data: serialize(subscription)})

      {:error, changeset} ->
        conn |> put_status(422) |> json(%{error: format_errors(changeset)})
    end
  end

  def update(conn, %{"id" => id} = params) do
    organization_id = conn.assigns.organization_id

    with {:ok, %{organization_id: ^organization_id} = subscription} <-
           LawChangeSubscription |> Ash.get(id) do
      attrs =
        params
        |> Map.take(
          ~w(name law_families geo_extent change_types keywords type_codes frequency delivery_methods enabled)
        )

      case subscription
           |> Ash.Changeset.for_update(:update, atomize_keys(attrs))
           |> Ash.update() do
        {:ok, updated} ->
          json(conn, %{data: serialize(updated)})

        {:error, changeset} ->
          conn |> put_status(422) |> json(%{error: format_errors(changeset)})
      end
    else
      _ -> conn |> put_status(404) |> json(%{error: "Not found"})
    end
  end

  def delete(conn, %{"id" => id}) do
    organization_id = conn.assigns.organization_id

    with {:ok, %{organization_id: ^organization_id} = subscription} <-
           LawChangeSubscription |> Ash.get(id),
         :ok <- Ash.destroy(subscription) do
      send_resp(conn, 204, "")
    else
      _ -> conn |> put_status(404) |> json(%{error: "Not found"})
    end
  end

  defp serialize(subscription) do
    %{
      id: subscription.id,
      organization_id: subscription.organization_id,
      user_id: subscription.user_id,
      name: subscription.name,
      law_families: subscription.law_families,
      geo_extent: subscription.geo_extent,
      change_types: subscription.change_types,
      keywords: subscription.keywords,
      type_codes: subscription.type_codes,
      frequency: subscription.frequency,
      delivery_methods: subscription.delivery_methods,
      enabled: subscription.enabled,
      inserted_at: subscription.inserted_at,
      updated_at: subscription.updated_at
    }
  end

  defp atomize_keys(map) do
    Map.new(map, fn {k, v} -> {String.to_existing_atom(k), v} end)
  end

  defp format_errors(%Ash.Error.Invalid{} = error) do
    error.errors
    |> Enum.map(fn e -> %{field: e.field, message: Exception.message(e)} end)
  end

  defp format_errors(error), do: inspect(error)
end
