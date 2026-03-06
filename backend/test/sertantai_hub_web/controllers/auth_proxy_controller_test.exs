defmodule SertantaiHubWeb.AuthProxyControllerTest do
  use SertantaiHubWeb.ConnCase, async: true

  import SertantaiHub.AuthHelpers

  # These tests use Req.Test stubs to verify the exact HTTP method and path
  # that AuthProxyController sends to the auth service. This catches route
  # mismatches (e.g. wrong path, wrong HTTP method) without needing a live
  # auth service.
  #
  # See: infrastructure/docs/ROUTING_ARCHITECTURE.md for the canonical mapping.

  setup do
    Application.put_env(:sertantai_hub, :auth_proxy_req_plug, {Req.Test, __MODULE__})
    on_exit(fn -> Application.delete_env(:sertantai_hub, :auth_proxy_req_plug) end)
    :ok
  end

  defp stub_and_capture(test_pid, expected_method, expected_path) do
    Req.Test.stub(__MODULE__, fn conn ->
      send(test_pid, {:proxy_request, conn.method, conn.request_path})

      assert conn.method == expected_method,
             "Expected #{expected_method} but got #{conn.method} for #{conn.request_path}"

      assert conn.request_path == expected_path,
             "Expected path #{expected_path} but got #{conn.request_path}"

      conn
      |> Plug.Conn.put_resp_content_type("application/json")
      |> Plug.Conn.send_resp(200, Jason.encode!(%{status: "ok"}))
    end)
  end

  # ──────────────────────────────────────────────────────────────────
  # Public endpoints — proxy method and path assertions
  # ──────────────────────────────────────────────────────────────────

  describe "GET /api/auth/github" do
    test "redirects to auth service GitHub OAuth endpoint", %{conn: conn} do
      conn = get(conn, "/api/auth/github")

      assert conn.status == 302
      [location] = get_resp_header(conn, "location")
      assert location =~ "/api/auth/user/github"
    end
  end

  describe "POST /api/auth/register" do
    test "proxies to POST /api/auth/user/password/register", %{conn: conn} do
      stub_and_capture(self(), "POST", "/api/auth/user/password/register")

      conn
      |> put_req_header("content-type", "application/json")
      |> post("/api/auth/register", %{user: %{email: "test@example.com", password: "password123"}})

      assert_receive {:proxy_request, "POST", "/api/auth/user/password/register"}
    end

    test "forwards user params to auth service", %{conn: conn} do
      test_pid = self()

      Req.Test.stub(__MODULE__, fn conn ->
        {:ok, body, conn} = Plug.Conn.read_body(conn)
        send(test_pid, {:proxy_body, Jason.decode!(body)})

        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.send_resp(200, Jason.encode!(%{status: "ok"}))
      end)

      conn
      |> put_req_header("content-type", "application/json")
      |> post("/api/auth/register", %{user: %{email: "test@example.com", password: "password123"}})

      assert_receive {:proxy_body, body}
      assert body["user"]["email"] == "test@example.com"
    end
  end

  describe "POST /api/auth/login" do
    test "proxies to POST /api/auth/user/password/sign_in", %{conn: conn} do
      stub_and_capture(self(), "POST", "/api/auth/user/password/sign_in")

      conn
      |> put_req_header("content-type", "application/json")
      |> post("/api/auth/login", %{user: %{email: "test@example.com", password: "password123"}})

      assert_receive {:proxy_request, "POST", "/api/auth/user/password/sign_in"}
    end
  end

  describe "POST /api/auth/logout" do
    test "proxies to GET /api/sign-out", %{conn: conn} do
      stub_and_capture(self(), "GET", "/api/sign-out")

      conn
      |> put_req_header("authorization", "Bearer fake-token")
      |> post("/api/auth/logout")

      assert_receive {:proxy_request, "GET", "/api/sign-out"}
    end

    test "forwards authorization header", %{conn: conn} do
      test_pid = self()

      Req.Test.stub(__MODULE__, fn conn ->
        auth = Plug.Conn.get_req_header(conn, "authorization")
        send(test_pid, {:proxy_auth, auth})

        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.send_resp(200, Jason.encode!(%{status: "ok"}))
      end)

      conn
      |> put_req_header("authorization", "Bearer my-token-123")
      |> post("/api/auth/logout")

      assert_receive {:proxy_auth, ["Bearer my-token-123"]}
    end
  end

  describe "POST /api/auth/refresh" do
    test "proxies to POST /api/refresh", %{conn: conn} do
      stub_and_capture(self(), "POST", "/api/refresh")

      conn
      |> put_req_header("authorization", "Bearer fake-token")
      |> post("/api/auth/refresh")

      assert_receive {:proxy_request, "POST", "/api/refresh"}
    end

    test "forwards authorization header", %{conn: conn} do
      test_pid = self()

      Req.Test.stub(__MODULE__, fn conn ->
        auth = Plug.Conn.get_req_header(conn, "authorization")
        send(test_pid, {:proxy_auth, auth})

        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.send_resp(200, Jason.encode!(%{status: "ok"}))
      end)

      conn
      |> put_req_header("authorization", "Bearer refresh-token-456")
      |> post("/api/auth/refresh")

      assert_receive {:proxy_auth, ["Bearer refresh-token-456"]}
    end
  end

  describe "POST /api/auth/magic-link/request" do
    test "proxies to POST /api/auth/user/magic_link/request", %{conn: conn} do
      stub_and_capture(self(), "POST", "/api/auth/user/magic_link/request")

      conn
      |> put_req_header("content-type", "application/json")
      |> post("/api/auth/magic-link/request", %{user: %{email: "test@example.com"}})

      assert_receive {:proxy_request, "POST", "/api/auth/user/magic_link/request"}
    end
  end

  describe "POST /api/auth/magic-link/callback" do
    test "proxies to POST /api/auth/user/magic_link", %{conn: conn} do
      stub_and_capture(self(), "POST", "/api/auth/user/magic_link")

      conn
      |> put_req_header("content-type", "application/json")
      |> post("/api/auth/magic-link/callback", %{token: "magic-link-token"})

      assert_receive {:proxy_request, "POST", "/api/auth/user/magic_link"}
    end
  end

  describe "POST /api/auth/totp/challenge" do
    test "proxies to POST /api/totp/challenge", %{conn: conn} do
      stub_and_capture(self(), "POST", "/api/totp/challenge")

      conn
      |> put_req_header("content-type", "application/json")
      |> post("/api/auth/totp/challenge", %{session_token: "session-token", code: "123456"})

      assert_receive {:proxy_request, "POST", "/api/totp/challenge"}
    end
  end

  describe "POST /api/auth/totp/recover" do
    test "proxies to POST /api/totp/recover", %{conn: conn} do
      stub_and_capture(self(), "POST", "/api/totp/recover")

      conn
      |> put_req_header("content-type", "application/json")
      |> post("/api/auth/totp/recover", %{session_token: "session-token", backup_code: "ABCD1234"})

      assert_receive {:proxy_request, "POST", "/api/totp/recover"}
    end
  end

  # ──────────────────────────────────────────────────────────────────
  # Authenticated endpoints — 401 without JWT + proxy assertions
  # ──────────────────────────────────────────────────────────────────

  describe "GET /api/auth/profile" do
    setup :setup_auth

    test "returns 401 without auth", %{conn: conn} do
      conn = get(conn, "/api/auth/profile")
      assert json_response(conn, 401)
    end

    test "proxies to GET /api/profile", %{conn: conn} do
      stub_and_capture(self(), "GET", "/api/profile")

      conn
      |> put_auth_header()
      |> get("/api/auth/profile")

      assert_receive {:proxy_request, "GET", "/api/profile"}
    end
  end

  describe "PATCH /api/auth/profile" do
    setup :setup_auth

    test "returns 401 without auth", %{conn: conn} do
      conn = patch(conn, "/api/auth/profile", %{name: "Test"})
      assert json_response(conn, 401)
    end

    test "proxies to PATCH /api/profile", %{conn: conn} do
      stub_and_capture(self(), "PATCH", "/api/profile")

      conn
      |> put_auth_header()
      |> put_req_header("content-type", "application/json")
      |> patch("/api/auth/profile", %{user: %{name: "New Name"}})

      assert_receive {:proxy_request, "PATCH", "/api/profile"}
    end

    test "forwards user params without double-wrapping", %{conn: conn} do
      test_pid = self()

      Req.Test.stub(__MODULE__, fn conn ->
        {:ok, body, conn} = Plug.Conn.read_body(conn)
        send(test_pid, {:proxy_body, Jason.decode!(body)})

        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.send_resp(200, Jason.encode!(%{status: "ok"}))
      end)

      conn
      |> put_auth_header()
      |> put_req_header("content-type", "application/json")
      |> patch("/api/auth/profile", %{user: %{name: "New Name"}})

      assert_receive {:proxy_body, body}
      assert body == %{"user" => %{"name" => "New Name"}}
    end
  end

  describe "POST /api/auth/profile/change-password" do
    setup :setup_auth

    test "returns 401 without auth", %{conn: conn} do
      conn = post(conn, "/api/auth/profile/change-password", %{})
      assert json_response(conn, 401)
    end

    test "proxies to POST /api/profile/change-password", %{conn: conn} do
      stub_and_capture(self(), "POST", "/api/profile/change-password")

      conn
      |> put_auth_header()
      |> put_req_header("content-type", "application/json")
      |> post("/api/auth/profile/change-password", %{
        current_password: "old",
        new_password: "new_password123"
      })

      assert_receive {:proxy_request, "POST", "/api/profile/change-password"}
    end
  end

  describe "GET /api/auth/organization" do
    setup :setup_auth

    test "returns 401 without auth", %{conn: conn} do
      conn = get(conn, "/api/auth/organization")
      assert json_response(conn, 401)
    end

    test "proxies to GET /api/organization", %{conn: conn} do
      stub_and_capture(self(), "GET", "/api/organization")

      conn
      |> put_auth_header()
      |> get("/api/auth/organization")

      assert_receive {:proxy_request, "GET", "/api/organization"}
    end
  end

  describe "PATCH /api/auth/organization" do
    setup :setup_auth

    test "returns 401 without auth", %{conn: conn} do
      conn = patch(conn, "/api/auth/organization", %{name: "Test"})
      assert json_response(conn, 401)
    end

    test "proxies to PATCH /api/organization", %{conn: conn} do
      stub_and_capture(self(), "PATCH", "/api/organization")

      conn
      |> put_auth_header()
      |> put_req_header("content-type", "application/json")
      |> patch("/api/auth/organization", %{name: "New Org Name"})

      assert_receive {:proxy_request, "PATCH", "/api/organization"}
    end
  end

  describe "GET /api/auth/totp/status" do
    setup :setup_auth

    test "returns 401 without auth", %{conn: conn} do
      conn = get(conn, "/api/auth/totp/status")
      assert json_response(conn, 401)
    end

    test "proxies to GET /api/totp/status", %{conn: conn} do
      stub_and_capture(self(), "GET", "/api/totp/status")

      conn
      |> put_auth_header()
      |> get("/api/auth/totp/status")

      assert_receive {:proxy_request, "GET", "/api/totp/status"}
    end
  end

  describe "POST /api/auth/totp/setup" do
    setup :setup_auth

    test "returns 401 without auth", %{conn: conn} do
      conn = post(conn, "/api/auth/totp/setup")
      assert json_response(conn, 401)
    end

    test "proxies to POST /api/totp/setup", %{conn: conn} do
      stub_and_capture(self(), "POST", "/api/totp/setup")

      conn
      |> put_auth_header()
      |> post("/api/auth/totp/setup")

      assert_receive {:proxy_request, "POST", "/api/totp/setup"}
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

    test "proxies to POST /api/totp/enable", %{conn: conn} do
      stub_and_capture(self(), "POST", "/api/totp/enable")

      conn
      |> put_auth_header()
      |> put_req_header("content-type", "application/json")
      |> post("/api/auth/totp/enable", %{code: "123456"})

      assert_receive {:proxy_request, "POST", "/api/totp/enable"}
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

    test "proxies to POST /api/totp/disable", %{conn: conn} do
      stub_and_capture(self(), "POST", "/api/totp/disable")

      conn
      |> put_auth_header()
      |> put_req_header("content-type", "application/json")
      |> post("/api/auth/totp/disable", %{code: "123456"})

      assert_receive {:proxy_request, "POST", "/api/totp/disable"}
    end
  end

  # ──────────────────────────────────────────────────────────────────
  # Response forwarding — auth service response is passed through
  # ──────────────────────────────────────────────────────────────────

  describe "response forwarding" do
    test "forwards auth service status code and body", %{conn: conn} do
      Req.Test.stub(__MODULE__, fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.send_resp(422, Jason.encode!(%{error: "invalid email"}))
      end)

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/auth/register", %{user: %{email: "bad", password: "password123"}})

      assert conn.status == 422
      assert json_response(conn, 422)["error"] == "invalid email"
    end
  end
end
