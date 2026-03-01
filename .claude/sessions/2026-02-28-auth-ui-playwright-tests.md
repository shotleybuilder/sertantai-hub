# Auth UI Playwright Test Coverage

**Started**: 2026-02-28
**Goal**: Major improvement to auth UI test coverage using Playwright

## Todo
- [x] Research Elixir/Phoenix Playwright library (Option A vs B)
- [x] Install Playwright frontend deps (`@playwright/test` + Chromium binary)
- [x] Set up Playwright test infrastructure and config
- [x] Review sertantai-auth test support endpoints and update plan
- [x] Create test helpers (seed, reset, email retrieval, TOTP code generation)
- [x] Write email/password registration + login integration tests
- [x] Write magic link authentication tests
- [x] Write TOTP (2FA) authentication tests

## Auth Service Test Support (sertantai-auth dev endpoints)

Tests use sertantai-auth's dev/test-only endpoints at `http://localhost:4000`:

| Endpoint | Purpose |
|----------|---------|
| `POST /dev/test/seed` | Create test user (with optional TOTP, role, tier) |
| `POST /dev/test/reset` | Clean up test data, clear emails/rate limiter |
| `GET /dev/test/emails?to=...` | Retrieve sent emails (for magic link/confirmation tokens) |
| `DELETE /dev/test/emails` | Clear email inbox |

### Seed response (when `totp: true`):
Returns `user_id`, `email`, `org_id`, `token`, `password`, `totp_secret`, `backup_codes`

## Hub Proxy Route Mapping (frontend → hub → auth)

| Frontend calls | Hub route | Auth service route |
|----------------|-----------|-------------------|
| `POST /api/auth/register` | `AuthProxyController.register` | `POST /api/auth/user/password/register` |
| `POST /api/auth/login` | `AuthProxyController.sign_in` | `POST /api/auth/user/password/sign_in` |
| `POST /api/auth/logout` | `AuthProxyController.sign_out` | `POST /api/sign_out` |
| `POST /api/auth/refresh` | `AuthProxyController.refresh` | `POST /api/refresh` |
| `POST /api/auth/magic-link/request` | `AuthProxyController.magic_link_request` | `POST /api/auth/user/magic_link/request` |
| `POST /api/auth/magic-link/callback` | `AuthProxyController.magic_link_callback` | `POST /api/auth/user/magic_link` |
| `POST /api/auth/totp/challenge` | `AuthProxyController.totp_challenge` | `POST /api/totp/challenge` |
| `POST /api/auth/totp/recover` | `AuthProxyController.totp_recover` | `POST /api/totp/recover` |
| `GET /api/auth/totp/status` | `AuthProxyController.totp_status` | `GET /api/totp/status` |
| `POST /api/auth/totp/setup` | `AuthProxyController.totp_setup` | `POST /api/totp/setup` |
| `POST /api/auth/totp/enable` | `AuthProxyController.totp_enable` | `POST /api/totp/enable` |
| `POST /api/auth/totp/disable` | `AuthProxyController.totp_disable` | `POST /api/totp/disable` |

## Test Plan

### Test Helpers (`frontend/tests/helpers/`)

**`auth-test-utils.ts`** — wrapper functions for sertantai-auth dev endpoints:
- `seedUser(opts?)` — POST /dev/test/seed, returns user details + TOTP secrets
- `resetTestData(opts?)` — POST /dev/test/reset
- `getEmails(email)` — GET /dev/test/emails?to=email, returns emails with extracted tokens
- `clearEmails()` — DELETE /dev/test/emails
- `generateTotpCode(secret)` — generate valid 6-digit TOTP code from secret (needs `otpauth` or similar npm lib)

### Test File: `frontend/tests/auth-register.spec.ts`

1. **Successful registration** — fill form → submit → redirected to dashboard, authenticated
2. **Validation: missing email** — submit without email → error message shown
3. **Validation: invalid email format** — bad email → client-side error
4. **Validation: short password** — <8 chars → error message
5. **Validation: passwords don't match** — mismatch → error message
6. **Duplicate email** — register same email twice → server error displayed
7. **Registration stores token** — after register, localStorage has `sertantai_token`

### Test File: `frontend/tests/auth-login.spec.ts`

1. **Successful login** — seed user → fill login form → submit → dashboard
2. **Invalid credentials** — wrong password → error message
3. **Non-existent user** — unknown email → error message
4. **Empty fields** — submit empty → validation errors
5. **Login stores token** — after login, localStorage has `sertantai_token`
6. **Redirect to login when unauthenticated** — visit /dashboard → redirected to /login

### Test File: `frontend/tests/auth-magic-link.spec.ts`

1. **Request magic link** — seed user → login page → click magic link → enter email → success message
2. **Complete magic link** — request link → fetch token from /dev/test/emails → navigate to /auth/magic-link?token=... → authenticated + redirected
3. **Invalid magic link token** — navigate with bad token → error message
4. **Magic link for non-existent email** — request for unknown email → still shows success (no user enumeration)

### Test File: `frontend/tests/auth-totp.spec.ts`

1. **Login with TOTP** — seed user with totp:true → login → redirected to /auth/totp-challenge → enter valid TOTP code → authenticated
2. **Invalid TOTP code** — enter wrong 6-digit code → error message
3. **Backup code recovery** — switch to backup code tab → enter valid backup code → authenticated
4. **Invalid backup code** — enter wrong backup code → error message
5. **TOTP setup flow** — seed user (no totp) → login → /settings/security → setup TOTP → QR shown → enter code → enabled
6. **TOTP disable flow** — seed user with totp:true → login (complete TOTP) → /settings/security → disable → enter code → disabled

## Decisions
- **Option B chosen** (`@playwright/test` in frontend) — tests the UI as a black box against real sertantai-auth
- Option A (`phoenix_test_playwright`) reserved for sertantai-auth's own test suite later
- Tests run against dev instance of sertantai-auth with dev/test DB — no mocking
- Flow: Playwright browser → SvelteKit (5173) → hub backend proxy (4006) → sertantai-auth → dev DB

## Installed
- `@playwright/test` — added to `frontend/package.json` devDependencies
- Chromium browser binary — installed to `~/.cache/ms-playwright/`

## Infrastructure Created
- `frontend/playwright.config.ts` — baseURL localhost:5173, Chromium only, trace on-first-retry, screenshots on failure
- `frontend/tests/` — e2e test directory
- npm scripts: `test:e2e`, `test:e2e:headed`, `test:e2e:debug`
- `frontend/tests/helpers/auth-test-utils.ts` — seedUser, resetTestData, getEmails, waitForEmail, clearEmails, generateTotpCode, uniqueEmail
- `frontend/tests/helpers/fixtures.ts` — Playwright fixtures: `createUser` (with auto-cleanup), `loginAsUser` (seeds + logs in via UI)
- `otpauth` npm dev dep — TOTP code generation from base32 secrets

## Results
- **32 passed, 2 skipped, 0 failed** (20.2s)
- Commit: `a2ccb2c` — pushed to `main`
- Skipped tests: TOTP disable + cancel-disable (seeded TOTP state not reflected by `/api/totp/status`)
- Bug filed: [shotleybuilder/sertantai-auth#15](https://github.com/shotleybuilder/sertantai-auth/issues/15)

## Notes
- Auth UI lives in this project (sertantai-hub frontend)
- Auth backend is a separate service (sertantai-auth) - backend only
- Production bug: real test users cannot register — high priority to cover with tests
- Run tests: `run-e2e` (requires `sert-hub-start --docker --auth` first)
