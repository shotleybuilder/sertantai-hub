defmodule SertantaiHubWeb.AuthProxyControllerTest do
  use SertantaiHubWeb.ConnCase, async: true

  describe "POST /api/auth/register" do
    test "returns 502 when auth service is unavailable", %{conn: conn} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/auth/register", %{
          user: %{email: "test@example.com", password: "password123"}
        })

      assert json_response(conn, 502)["status"] == "error"
      assert json_response(conn, 502)["message"] =~ "Auth service"
    end
  end

  describe "POST /api/auth/login" do
    test "returns 502 when auth service is unavailable", %{conn: conn} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/auth/login", %{user: %{email: "test@example.com", password: "password123"}})

      assert json_response(conn, 502)["status"] == "error"
      assert json_response(conn, 502)["message"] =~ "Auth service"
    end
  end

  describe "POST /api/auth/logout" do
    test "returns 502 when auth service is unavailable", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer fake-token")
        |> post("/api/auth/logout")

      assert json_response(conn, 502)["status"] == "error"
    end
  end

  describe "POST /api/auth/refresh" do
    test "returns 502 when auth service is unavailable", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer fake-token")
        |> post("/api/auth/refresh")

      assert json_response(conn, 502)["status"] == "error"
    end
  end
end
