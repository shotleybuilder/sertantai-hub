defmodule SertantaiHubWeb.WebhookAuthPlugTest do
  use SertantaiHubWeb.ConnCase, async: true

  alias SertantaiHubWeb.WebhookAuthPlug

  describe "call/2" do
    test "passes with valid API key", %{conn: conn} do
      conn =
        conn
        |> put_req_header("x-api-key", "test-webhook-key")
        |> WebhookAuthPlug.call([])

      refute conn.halted
    end

    test "rejects with invalid API key", %{conn: conn} do
      conn =
        conn
        |> put_req_header("x-api-key", "wrong-key")
        |> WebhookAuthPlug.call([])

      assert conn.halted
      assert conn.status == 401
    end

    test "rejects with missing API key", %{conn: conn} do
      conn = WebhookAuthPlug.call(conn, [])

      assert conn.halted
      assert conn.status == 401
    end
  end
end
