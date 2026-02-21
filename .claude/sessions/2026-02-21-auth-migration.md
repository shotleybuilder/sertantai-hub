# Auth Migration: HS256 to EdDSA/JWKS

**Started**: 2026-02-21
**Reference**: sertantai-legal (completed), SKILL.md in sertantai-auth

## Todo
- [x] Add `{:jose, "~> 1.11"}` to mix.exs deps
- [x] Create `lib/sertantai_hub/auth/jwks_client.ex`
- [x] Create `lib/sertantai_hub_web/plugs/load_from_cookie.ex`
- [x] Create `lib/sertantai_hub_web/plugs/auth_plug.ex`
- [x] Add JwksClient to supervision tree in application.ex
- [x] Update config: dev.exs, test.exs, runtime.exs (auth_url, test_mode, jwks_req_plug)
- [x] Add authenticated pipeline to router.ex
- [x] Create test/support/auth_helpers.ex
- [x] Create test for JwksClient
- [x] Create test for AuthPlug
- [x] Create test for LoadFromCookie
- [x] Clean up .env.example (remove GUARDIAN/TOKEN_SIGNING_SECRET placeholders)
- [x] Run mix test (35 pass), mix credo (no issues), mix format (clean)

**Ended**: 2026-02-21
**Committed**: be31da2

## Notes
- Hub was proxy-only: AuthProxyController forwards to sertantai-auth, no JWT validation
- Added EdDSA/JWKS infrastructure matching sertantai-legal reference impl
- Auth proxy routes remain public, `api_authenticated` pipeline ready for future protected routes
- `auth_url` config key added (separate from existing `auth_service_url` used by proxy)
- AUTH_URL required in production (runtime.exs raises if missing)
