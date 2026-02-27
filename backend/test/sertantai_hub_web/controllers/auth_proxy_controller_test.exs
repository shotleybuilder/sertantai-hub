defmodule SertantaiHubWeb.AuthProxyControllerTest do
  use SertantaiHubWeb.ConnCase, async: true

  import SertantaiHub.AuthHelpers

  # These tests verify the proxy routes exist and return JSON responses.
  # Results depend on whether sertantai-auth is running:
  #   - Auth running: forwards to auth service, returns auth response
  #   - Auth down: returns 502 with error message
  #
  # Authenticated endpoints (profile, TOTP management) additionally verify
  # that requests without a valid JWT are rejected with 401.

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

  describe "POST /api/auth/magic-link/request" do
    test "proxies to auth service and returns JSON", %{conn: conn} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/auth/magic-link/request", %{
          user: %{email: "magic-test@example.com"}
        })

      assert json_response(conn, conn.status)
      assert conn.status in [200, 401, 422, 429, 500, 502]
    end
  end

  describe "POST /api/auth/magic-link/callback" do
    test "proxies to auth service and returns JSON", %{conn: conn} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/auth/magic-link/callback", %{token: "fake-magic-link-token"})

      assert json_response(conn, conn.status)
      assert conn.status in [200, 401, 403, 500, 502]
    end
  end

  # ──────────────────────────────────────────────────────────────────
  # Authenticated endpoints — require valid JWT
  # ──────────────────────────────────────────────────────────────────

  describe "GET /api/auth/profile" do
    setup :setup_auth

    test "returns 401 without auth", %{conn: conn} do
      conn = get(conn, "/api/auth/profile")
      assert json_response(conn, 401)
    end

    test "proxies to auth service with valid token", %{conn: conn} do
      conn =
        conn
        |> put_auth_header()
        |> get("/api/auth/profile")

      assert json_response(conn, conn.status)
      assert conn.status in [200, 401, 500, 502]
    end
  end

  describe "PATCH /api/auth/profile" do
    setup :setup_auth

    test "returns 401 without auth", %{conn: conn} do
      conn = patch(conn, "/api/auth/profile", %{name: "Test"})
      assert json_response(conn, 401)
    end

    test "proxies to auth service with valid token", %{conn: conn} do
      conn =
        conn
        |> put_auth_header()
        |> patch("/api/auth/profile", %{user: %{name: "Test User"}})

      assert json_response(conn, conn.status)
      assert conn.status in [200, 401, 422, 500, 502]
    end

    test "forwards user params without double-wrapping", %{conn: conn} do
      # Temporarily enable Req.Test plug for the proxy
      Application.put_env(:sertantai_hub, :auth_proxy_req_plug, {Req.Test, __MODULE__})
      on_exit(fn -> Application.delete_env(:sertantai_hub, :auth_proxy_req_plug) end)

      # Stub the auth service to capture the request body
      test_pid = self()

      Req.Test.stub(__MODULE__, fn conn ->
        {:ok, body, conn} = Plug.Conn.read_body(conn)
        send(test_pid, {:proxy_body, Jason.decode!(body)})

        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.send_resp(
          200,
          Jason.encode!(%{status: "success", user: %{name: "New Name"}})
        )
      end)

      conn
      |> put_auth_header()
      |> put_req_header("content-type", "application/json")
      |> patch("/api/auth/profile", %{user: %{name: "New Name"}})

      assert_receive {:proxy_body, body}

      # The auth service expects {"user": {"name": "..."}}, NOT {"user": {"user": {"name": "..."}}}
      assert body == %{"user" => %{"name" => "New Name"}},
             "Expected {\"user\": {\"name\": \"New Name\"}} but got: #{Jason.encode!(body)}"
    end
  end

  describe "POST /api/auth/profile/change-password" do
    setup :setup_auth

    test "returns 401 without auth", %{conn: conn} do
      conn = post(conn, "/api/auth/profile/change-password", %{})
      assert json_response(conn, 401)
    end

    test "proxies to auth service with valid token", %{conn: conn} do
      conn =
        conn
        |> put_auth_header()
        |> post("/api/auth/profile/change-password", %{
          current_password: "old_password",
          new_password: "new_password123"
        })

      assert json_response(conn, conn.status)
      assert conn.status in [200, 400, 401, 422, 500, 502]
    end
  end

  describe "GET /api/auth/totp/status" do
    setup :setup_auth

    test "returns 401 without auth", %{conn: conn} do
      conn = get(conn, "/api/auth/totp/status")
      assert json_response(conn, 401)
    end

    test "proxies to auth service with valid token", %{conn: conn} do
      conn =
        conn
        |> put_auth_header()
        |> get("/api/auth/totp/status")

      assert json_response(conn, conn.status)
      assert conn.status in [200, 401, 500, 502]
    end
  end

  describe "POST /api/auth/totp/setup" do
    setup :setup_auth

    test "returns 401 without auth", %{conn: conn} do
      conn = post(conn, "/api/auth/totp/setup")
      assert json_response(conn, 401)
    end

    test "proxies to auth service with valid token", %{conn: conn} do
      conn =
        conn
        |> put_auth_header()
        |> post("/api/auth/totp/setup")

      assert json_response(conn, conn.status)
      assert conn.status in [200, 401, 500, 502]
    end
  end

  describe "POST /api/auth/totp/enable" do
    setup :setup_auth

    test "returns 401 without auth", %{conn: conn} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/auth/totp/enable", %{code: "000000"})

      assert json_response(conn, 401)
    end

    test "proxies to auth service with valid token", %{conn: conn} do
      conn =
        conn
        |> put_auth_header()
        |> put_req_header("content-type", "application/json")
        |> post("/api/auth/totp/enable", %{code: "000000"})

      assert json_response(conn, conn.status)
      assert conn.status in [200, 400, 401, 500, 502]
    end
  end

  describe "POST /api/auth/totp/disable" do
    setup :setup_auth

    test "returns 401 without auth", %{conn: conn} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/auth/totp/disable", %{code: "000000"})

      assert json_response(conn, 401)
    end

    test "proxies to auth service with valid token", %{conn: conn} do
      conn =
        conn
        |> put_auth_header()
        |> put_req_header("content-type", "application/json")
        |> post("/api/auth/totp/disable", %{code: "000000"})

      assert json_response(conn, conn.status)
      assert conn.status in [200, 400, 401, 500, 502]
    end
  end

  # ──────────────────────────────────────────────────────────────────
  # Public endpoints — no JWT required (used during login flow)
  # ──────────────────────────────────────────────────────────────────

  describe "POST /api/auth/totp/challenge" do
    test "proxies to auth service and returns JSON", %{conn: conn} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/auth/totp/challenge", %{session_token: "fake-session-token", code: "000000"})

      assert json_response(conn, conn.status)
      assert conn.status in [200, 400, 401, 429, 500, 502]
    end
  end

  describe "POST /api/auth/totp/recover" do
    test "proxies to auth service and returns JSON", %{conn: conn} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/auth/totp/recover", %{
          session_token: "fake-session-token",
          backup_code: "ABCD1234"
        })

      assert json_response(conn, conn.status)
      assert conn.status in [200, 400, 401, 429, 500, 502]
    end
  end
end
