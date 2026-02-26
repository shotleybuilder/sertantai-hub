defmodule SertantaiHubWeb.WebhookControllerTest do
  use SertantaiHubWeb.ConnCase, async: true

  describe "POST /api/webhooks/law-change" do
    test "returns 401 without API key", %{conn: conn} do
      conn = post(conn, "/api/webhooks/law-change", %{})
      assert json_response(conn, 401)["error"] =~ "API key"
    end

    test "returns 202 with valid payload and API key", %{conn: conn} do
      payload = %{
        "changes" => [
          %{
            "law_name" => "ukpga/2025/42",
            "law_title" => "Climate Change Act 2025",
            "change_type" => "new",
            "families" => ["E:CLIMATE"],
            "geo_extent" => "S",
            "type_code" => "asp"
          }
        ],
        "batch_id" => "scrape-2025-03-15",
        "timestamp" => "2025-03-15T10:30:00Z"
      }

      conn =
        conn
        |> put_req_header("x-api-key", "test-webhook-key")
        |> post("/api/webhooks/law-change", payload)

      response = json_response(conn, 202)
      assert response["status"] == "accepted"
      assert response["changes_queued"] == 1
    end

    test "returns 202 with empty changes array", %{conn: conn} do
      payload = %{
        "changes" => [],
        "batch_id" => "scrape-empty",
        "timestamp" => "2025-03-15T10:30:00Z"
      }

      conn =
        conn
        |> put_req_header("x-api-key", "test-webhook-key")
        |> post("/api/webhooks/law-change", payload)

      response = json_response(conn, 202)
      assert response["changes_queued"] == 0
    end

    test "returns 400 with invalid payload", %{conn: conn} do
      conn =
        conn
        |> put_req_header("x-api-key", "test-webhook-key")
        |> post("/api/webhooks/law-change", %{"invalid" => "data"})

      assert json_response(conn, 400)["error"] =~ "Invalid payload"
    end
  end
end
