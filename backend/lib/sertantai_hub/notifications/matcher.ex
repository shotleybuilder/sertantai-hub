defmodule SertantaiHub.Notifications.Matcher do
  @moduledoc """
  Pure matching logic for law change notifications.

  Determines whether a law change matches a subscription's filter criteria.
  All filters use AND logic across dimensions (all specified filters must match).
  Within each array filter, OR logic applies (any value can match).
  An empty or nil filter means "match all" (no constraint on that dimension).
  """

  alias SertantaiHub.Notifications.LawChangeSubscription

  @doc """
  Returns all enabled subscriptions that match the given law change.
  """
  def find_matching_subscriptions(law_change) do
    {:ok, subscriptions} = LawChangeSubscription.enabled_for_matching()

    Enum.filter(subscriptions, &matches?(&1, law_change))
  end

  @doc """
  Checks if a single subscription matches a law change.

  A subscription matches when ALL specified filters match:
  - `law_families`: change's families intersect subscription's families
  - `geo_extent`: change's extent is in subscription's extent list
  - `change_types`: change's type is in subscription's types
  - `keywords`: any keyword appears in law title or name (case-insensitive)
  - `type_codes`: change's type_code is in subscription's type_codes
  """
  def matches?(subscription, law_change) do
    match_law_families?(subscription.law_families, law_change) &&
      match_geo_extent?(subscription.geo_extent, law_change) &&
      match_change_types?(subscription.change_types, law_change) &&
      match_keywords?(subscription.keywords, law_change) &&
      match_type_codes?(subscription.type_codes, law_change)
  end

  # Empty/nil filter = match all
  defp match_law_families?(nil, _change), do: true
  defp match_law_families?([], _change), do: true

  defp match_law_families?(filter_families, %{"families" => change_families})
       when is_list(change_families) do
    Enum.any?(change_families, &(&1 in filter_families))
  end

  defp match_law_families?(_filter_families, _change), do: true

  defp match_geo_extent?(nil, _change), do: true
  defp match_geo_extent?([], _change), do: true

  defp match_geo_extent?(filter_extents, %{"geo_extent" => change_extent})
       when is_binary(change_extent) do
    change_extent in filter_extents
  end

  defp match_geo_extent?(_filter_extents, _change), do: true

  defp match_change_types?(nil, _change), do: true
  defp match_change_types?([], _change), do: true

  defp match_change_types?(filter_types, %{"change_type" => change_type})
       when is_binary(change_type) do
    change_type in filter_types
  end

  defp match_change_types?(_filter_types, _change), do: true

  defp match_keywords?(nil, _change), do: true
  defp match_keywords?([], _change), do: true

  defp match_keywords?(filter_keywords, change) do
    searchable =
      [
        Map.get(change, "law_title", ""),
        Map.get(change, "law_name", "")
      ]
      |> Enum.join(" ")
      |> String.downcase()

    Enum.any?(filter_keywords, fn keyword ->
      String.contains?(searchable, String.downcase(keyword))
    end)
  end

  defp match_type_codes?(nil, _change), do: true
  defp match_type_codes?([], _change), do: true

  defp match_type_codes?(filter_codes, %{"type_code" => change_code})
       when is_binary(change_code) do
    change_code in filter_codes
  end

  defp match_type_codes?(_filter_codes, _change), do: true
end
