defmodule SertantaiHubWeb.SubscriptionControllerTest do
  use SertantaiHubWeb.ConnCase, async: true

  import SertantaiHub.AuthHelpers
  import SertantaiHub.NotificationHelpers

  setup :setup_auth

  @test_org_id SertantaiHub.NotificationHelpers.default_org_id()
  @test_user_id SertantaiHub.NotificationHelpers.default_user_id()

  setup do
    create_test_org(id: @test_org_id)
    create_test_user(id: @test_user_id, organization_id: @test_org_id)
    :ok
  end

  # Override JWT claims to match our test data UUIDs
  defp auth_header(conn) do
    put_auth_header(conn, %{
      "sub" => "user?id=#{@test_user_id}",
      "org_id" => @test_org_id
    })
  end

  describe "GET /api/subscriptions" do
    test "returns empty list when no subscriptions", %{conn: conn} do
      conn =
        conn
        |> auth_header()
        |> get("/api/subscriptions")

      assert json_response(conn, 200)["data"] == []
    end

    test "returns user's subscriptions", %{conn: conn} do
      create_test_subscription(%{name: "My Sub"})

      conn =
        conn
        |> auth_header()
        |> get("/api/subscriptions")

      data = json_response(conn, 200)["data"]
      assert length(data) == 1
      assert hd(data)["name"] == "My Sub"
    end

    test "returns 401 without auth", %{conn: conn} do
      conn = get(conn, "/api/subscriptions")
      assert json_response(conn, 401)
    end
  end

  describe "POST /api/subscriptions" do
    test "creates a subscription", %{conn: conn} do
      conn =
        conn
        |> auth_header()
        |> post("/api/subscriptions", %{
          "name" => "Scottish Laws",
          "law_families" => ["E:CLIMATE"],
          "geo_extent" => ["S"],
          "change_types" => ["new"]
        })

      data = json_response(conn, 201)["data"]
      assert data["name"] == "Scottish Laws"
      assert data["law_families"] == ["E:CLIMATE"]
      assert data["frequency"] == "daily_digest"
    end

    test "returns 422 for missing required fields", %{conn: conn} do
      conn =
        conn
        |> auth_header()
        |> post("/api/subscriptions", %{})

      assert json_response(conn, 422)
    end
  end

  describe "GET /api/subscriptions/:id" do
    test "returns a specific subscription", %{conn: conn} do
      sub = create_test_subscription(%{name: "Specific Sub"})

      conn =
        conn
        |> auth_header()
        |> get("/api/subscriptions/#{sub.id}")

      data = json_response(conn, 200)["data"]
      assert data["name"] == "Specific Sub"
    end

    test "returns 404 for non-existent subscription", %{conn: conn} do
      conn =
        conn
        |> auth_header()
        |> get("/api/subscriptions/#{Ash.UUID.generate()}")

      assert json_response(conn, 404)
    end
  end

  describe "PATCH /api/subscriptions/:id" do
    test "updates a subscription", %{conn: conn} do
      sub = create_test_subscription(%{name: "Original"})

      conn =
        conn
        |> auth_header()
        |> patch("/api/subscriptions/#{sub.id}", %{"name" => "Updated"})

      data = json_response(conn, 200)["data"]
      assert data["name"] == "Updated"
    end
  end

  describe "DELETE /api/subscriptions/:id" do
    test "deletes a subscription", %{conn: conn} do
      sub = create_test_subscription(%{name: "To Delete"})

      conn =
        conn
        |> auth_header()
        |> delete("/api/subscriptions/#{sub.id}")

      assert response(conn, 204)
    end
  end
end
