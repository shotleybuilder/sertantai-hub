defmodule SertantaiHubWeb.AuthPlugTest do
  use SertantaiHubWeb.ConnCase, async: false

  import SertantaiHub.AuthHelpers

  setup :setup_auth

  @plug_opts SertantaiHubWeb.AuthPlug.init([])

  defp call_auth_plug(conn) do
    SertantaiHubWeb.AuthPlug.call(conn, @plug_opts)
  end

  describe "call/2" do
    test "sets assigns from valid token", %{conn: conn} do
      conn =
        conn
        |> put_auth_header()
        |> call_auth_plug()

      assert conn.assigns.current_user_id == default_user_id()
      assert conn.assigns.organization_id == default_org_id()
      assert conn.assigns.user_role == "owner"
      assert is_map(conn.assigns.jwt_claims)
    end

    test "accepts custom claims", %{conn: conn} do
      conn =
        conn
        |> put_auth_header(%{"role" => "member", "org_id" => "custom-org-id"})
        |> call_auth_plug()

      assert conn.assigns.user_role == "member"
      assert conn.assigns.organization_id == "custom-org-id"
    end

    test "parses AshAuthentication sub format", %{conn: conn} do
      user_id = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"

      conn =
        conn
        |> put_auth_header(%{"sub" => "user?id=#{user_id}"})
        |> call_auth_plug()

      assert conn.assigns.current_user_id == user_id
    end

    test "parses bare UUID sub format", %{conn: conn} do
      user_id = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"

      conn =
        conn
        |> put_auth_header(%{"sub" => user_id})
        |> call_auth_plug()

      assert conn.assigns.current_user_id == user_id
    end
  end

  describe "error cases" do
    test "returns 401 without auth header", %{conn: conn} do
      # Need to hit an authenticated route to trigger the plug.
      # Since /api/hello is public, we test the plug directly.
      conn =
        conn
        |> SertantaiHubWeb.AuthPlug.call(SertantaiHubWeb.AuthPlug.init([]))

      assert conn.status == 401
      assert conn.halted
      body = Jason.decode!(conn.resp_body)
      assert body["error"] == "Unauthorized"
    end

    test "returns 401 for expired token", %{conn: conn} do
      token = build_expired_token()

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> SertantaiHubWeb.AuthPlug.call(SertantaiHubWeb.AuthPlug.init([]))

      assert conn.status == 401
      body = Jason.decode!(conn.resp_body)
      assert body["reason"] == "Token expired"
    end

    test "returns 401 for malformed token", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer not-a-jwt")
        |> SertantaiHubWeb.AuthPlug.call(SertantaiHubWeb.AuthPlug.init([]))

      assert conn.status == 401
      assert conn.halted
    end

    test "returns 401 when no signing key available", %{conn: conn} do
      SertantaiHub.Auth.JwksClient.set_test_key(nil)

      conn =
        conn
        |> put_auth_header()
        |> SertantaiHubWeb.AuthPlug.call(SertantaiHubWeb.AuthPlug.init([]))

      assert conn.status == 401
      body = Jason.decode!(conn.resp_body)
      assert body["reason"] == "Auth service unavailable (no signing key)"
    end

    test "returns 401 for token signed with wrong key", %{conn: conn} do
      # Sign with a different key than the one registered with JwksClient
      wrong_key = JOSE.JWK.generate_key({:okp, :Ed25519})
      now = System.system_time(:second)

      claims = %{
        "sub" => "user?id=test-user",
        "org_id" => "test-org",
        "role" => "owner",
        "exp" => now + 3600,
        "iat" => now
      }

      jws = %{"alg" => "EdDSA"}
      {_, token} = JOSE.JWT.sign(wrong_key, jws, claims) |> JOSE.JWS.compact()

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> SertantaiHubWeb.AuthPlug.call(SertantaiHubWeb.AuthPlug.init([]))

      assert conn.status == 401
      body = Jason.decode!(conn.resp_body)
      assert body["reason"] == "Invalid token signature"
    end

    test "returns 401 for token missing sub claim", %{conn: conn} do
      token = build_token(%{"sub" => nil})

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> SertantaiHubWeb.AuthPlug.call(SertantaiHubWeb.AuthPlug.init([]))

      assert conn.status == 401
      body = Jason.decode!(conn.resp_body)
      assert body["reason"] == "Token missing sub claim"
    end
  end
end
