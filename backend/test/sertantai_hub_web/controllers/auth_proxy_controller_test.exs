defmodule SertantaiHubWeb.AuthProxyControllerTest do
  use SertantaiHubWeb.ConnCase, async: true

  # These tests verify the proxy routes exist and return JSON responses.
  # Results depend on whether sertantai-auth is running:
  #   - Auth running: forwards to auth service, returns auth response
  #   - Auth down: returns 502 with error message

  describe "POST /api/auth/register" do
    test "proxies to auth service and returns JSON", %{conn: conn} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/auth/register", %{
          user: %{
            email: "proxy-test-#{System.unique_integer()}@example.com",
            password: "password123456"
          }
        })

      assert json_response(conn, conn.status)
      assert conn.status in [200, 201, 401, 422, 500, 502]
    end
  end

  describe "POST /api/auth/login" do
    test "proxies to auth service and returns JSON", %{conn: conn} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/auth/login", %{
          user: %{email: "nonexistent@example.com", password: "wrongpassword123"}
        })

      assert json_response(conn, conn.status)
      assert conn.status in [200, 401, 500, 502]
    end
  end

  describe "POST /api/auth/logout" do
    test "proxies to auth service and returns JSON", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer fake-token")
        |> post("/api/auth/logout")

      assert json_response(conn, conn.status)
      assert conn.status in [200, 401, 404, 500, 502]
    end
  end

  describe "POST /api/auth/refresh" do
    test "proxies to auth service and returns JSON", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer fake-token")
        |> post("/api/auth/refresh")

      assert json_response(conn, conn.status)
      assert conn.status in [200, 401, 404, 500, 502]
    end
  end
end
