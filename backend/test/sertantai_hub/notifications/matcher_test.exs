defmodule SertantaiHub.Notifications.MatcherTest do
  use SertantaiHub.DataCase, async: true

  alias SertantaiHub.Notifications.Matcher

  import SertantaiHub.NotificationHelpers

  describe "matches?/2" do
    test "matches when all filters are empty (match all)" do
      sub = %{law_families: [], geo_extent: [], change_types: [], keywords: [], type_codes: []}
      assert Matcher.matches?(sub, sample_law_change())
    end

    test "matches when all filters are nil (match all)" do
      sub = %{
        law_families: nil,
        geo_extent: nil,
        change_types: nil,
        keywords: nil,
        type_codes: nil
      }

      assert Matcher.matches?(sub, sample_law_change())
    end

    test "matches law_families when change families intersect" do
      sub = %{
        law_families: ["E:CLIMATE", "E:ENVIRONMENT"],
        geo_extent: [],
        change_types: [],
        keywords: [],
        type_codes: []
      }

      assert Matcher.matches?(sub, sample_law_change(%{"families" => ["E:CLIMATE"]}))
    end

    test "does not match law_families when no intersection" do
      sub = %{
        law_families: ["HS:HEALTH"],
        geo_extent: [],
        change_types: [],
        keywords: [],
        type_codes: []
      }

      refute Matcher.matches?(sub, sample_law_change(%{"families" => ["E:CLIMATE"]}))
    end

    test "matches geo_extent when change extent is in filter list" do
      sub = %{
        law_families: [],
        geo_extent: ["S", "E+W"],
        change_types: [],
        keywords: [],
        type_codes: []
      }

      assert Matcher.matches?(sub, sample_law_change(%{"geo_extent" => "S"}))
    end

    test "does not match geo_extent when change extent not in filter" do
      sub = %{
        law_families: [],
        geo_extent: ["E+W"],
        change_types: [],
        keywords: [],
        type_codes: []
      }

      refute Matcher.matches?(sub, sample_law_change(%{"geo_extent" => "S"}))
    end

    test "matches change_types when change type is in filter" do
      sub = %{
        law_families: [],
        geo_extent: [],
        change_types: ["new", "amended"],
        keywords: [],
        type_codes: []
      }

      assert Matcher.matches?(sub, sample_law_change(%{"change_type" => "new"}))
    end

    test "does not match change_types when change type not in filter" do
      sub = %{
        law_families: [],
        geo_extent: [],
        change_types: ["repealed"],
        keywords: [],
        type_codes: []
      }

      refute Matcher.matches?(sub, sample_law_change(%{"change_type" => "new"}))
    end

    test "matches keywords case-insensitively in title" do
      sub = %{
        law_families: [],
        geo_extent: [],
        change_types: [],
        keywords: ["climate change"],
        type_codes: []
      }

      assert Matcher.matches?(sub, sample_law_change(%{"law_title" => "Climate Change Act"}))
    end

    test "matches keywords in law_name" do
      sub = %{
        law_families: [],
        geo_extent: [],
        change_types: [],
        keywords: ["ukpga"],
        type_codes: []
      }

      assert Matcher.matches?(sub, sample_law_change(%{"law_name" => "ukpga/2025/42"}))
    end

    test "does not match keywords when none found" do
      sub = %{
        law_families: [],
        geo_extent: [],
        change_types: [],
        keywords: ["emissions"],
        type_codes: []
      }

      refute Matcher.matches?(
               sub,
               sample_law_change(%{"law_title" => "Finance Act", "law_name" => "ukpga/2025/1"})
             )
    end

    test "matches type_codes when change type_code is in filter" do
      sub = %{
        law_families: [],
        geo_extent: [],
        change_types: [],
        keywords: [],
        type_codes: ["asp", "ukpga"]
      }

      assert Matcher.matches?(sub, sample_law_change(%{"type_code" => "asp"}))
    end

    test "does not match type_codes when not in filter" do
      sub = %{
        law_families: [],
        geo_extent: [],
        change_types: [],
        keywords: [],
        type_codes: ["uksi"]
      }

      refute Matcher.matches?(sub, sample_law_change(%{"type_code" => "asp"}))
    end

    test "requires ALL filters to match (AND logic)" do
      sub = %{
        law_families: ["E:CLIMATE"],
        geo_extent: ["E+W"],
        change_types: [],
        keywords: [],
        type_codes: []
      }

      # families match but geo_extent doesn't
      refute Matcher.matches?(
               sub,
               sample_law_change(%{"families" => ["E:CLIMATE"], "geo_extent" => "S"})
             )
    end

    test "matches when all specified filters match" do
      sub = %{
        law_families: ["E:CLIMATE"],
        geo_extent: ["S"],
        change_types: ["new"],
        keywords: ["climate"],
        type_codes: ["asp"]
      }

      assert Matcher.matches?(sub, sample_law_change())
    end
  end
end
