defmodule SertantaiHub.AuthHelpers do
  @moduledoc """
  Test helpers for JWT authentication.

  Generates valid EdDSA (Ed25519) JWT tokens locally using JOSE, matching
  the format produced by sertantai-auth. The test keypair is generated at
  compile time and the public key is registered with `JwksClient` via
  `setup_auth/0`.

  ## Usage

      # In tests:
      import SertantaiHub.AuthHelpers

      setup :setup_auth

      test "requires auth", %{conn: conn} do
        conn = conn |> put_auth_header() |> get("/api/protected")
        assert json_response(conn, 200)
      end
  """

  @default_user_id "test-user-00000000-0000-0000-0000-000000000001"
  @default_org_id "test-org-00000000-0000-0000-0000-000000000001"

  # Ed25519 test keypair — generated at compile time, stable across test runs
  @test_private_key JOSE.JWK.generate_key({:okp, :Ed25519})
  @test_public_key JOSE.JWK.to_public(@test_private_key)

  def setup_auth(_context \\ %{}) do
    :ok = SertantaiHub.Auth.JwksClient.set_test_key(@test_public_key)
    :ok
  end

  def test_private_key, do: @test_private_key
  def test_public_key, do: @test_public_key

  def build_token(overrides \\ %{}) do
    now = System.system_time(:second)

    claims =
      %{
        "sub" => "user?id=#{@default_user_id}",
        "org_id" => @default_org_id,
        "role" => "owner",
        "iss" => "AshAuthentication v4.12.0",
        "aud" => "~> 4.12",
        "exp" => now + 3600,
        "iat" => now,
        "nbf" => now,
        "jti" => Base.encode16(:crypto.strong_rand_bytes(12), case: :lower)
      }
      |> Map.merge(overrides)

    jws = %{"alg" => "EdDSA"}
    {_, token} = JOSE.JWT.sign(@test_private_key, jws, claims) |> JOSE.JWS.compact()
    token
  end

  def build_expired_token(overrides \\ %{}) do
    build_token(Map.merge(%{"exp" => System.system_time(:second) - 3600}, overrides))
  end

  def put_auth_header(conn, overrides \\ %{}) do
    token = build_token(overrides)
    Plug.Conn.put_req_header(conn, "authorization", "Bearer #{token}")
  end

  def default_user_id, do: @default_user_id
  def default_org_id, do: @default_org_id
end
