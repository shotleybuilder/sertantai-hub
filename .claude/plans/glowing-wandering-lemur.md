# Issue #14: Operationalise Organisation Card on Dashboard

## Context

The Organisation card on the Dashboard currently shows "Coming Soon" with a truncated org UUID. The goal is to make it functional: link it to an Organisation Settings page where users can view/edit their org name, see tier and slug, and have the dashboard card display the org name instead of a truncated ID.

The auth service already has a full `Organization` Ash resource with name, slug, tier, and settings attributes — but **no HTTP endpoints** to read or update it. The hub follows an auth-proxy pattern where the frontend calls hub, which proxies to auth.

## Plan

### Phase 1: Auth Service — Add OrganizationController (sertantai-auth)

**New file**: `lib/sertantai_auth_web/controllers/organization_controller.ex`

Follow the ProfileController pattern (`profile_controller.ex`):

- **`show/2`** — `GET /api/organization`
  - Get `conn.assigns[:current_user]`, load `:organization` relationship
  - Return `%{status: "success", organization: %{id, name, slug, tier, settings}}`

- **`update/2`** — `PATCH /api/organization`
  - Pattern match `%{"organization" => params}`
  - Whitelist `["name"]` only (slug/tier not user-editable)
  - Use `Ash.Changeset.for_update(:update, allowed) |> Ash.update(authorize?: false)`
  - Return updated org or 422 with errors
  - Catch-all clause returns 400 for missing `"organization"` key

**Route changes** in `router.ex` — add to the authenticated scope:
```elixir
get "/api/organization", OrganizationController, :show
patch "/api/organization", OrganizationController, :update
```

**Tests**: `test/sertantai_auth_web/controllers/organization_controller_test.exs`
- GET returns org data for authenticated user
- PATCH updates org name
- PATCH rejects invalid/empty params
- 401 for unauthenticated requests

### Phase 2: Auth Service — Add `org_name` to JWT Claims

**File**: `lib/sertantai_auth_web/controllers/auth_controller.ex`

In `success_with_user/3` and `issue_refreshed_token/2`, the JWT claims already include `org_id`, `role`, `tier`, `name` (user name). Add `org_name`:

```elixir
jwt_claims = %{
  "org_id" => user.organization_id,
  "role" => to_string(user.role),
  "tier" => to_string(org_tier),
  "name" => user.name,
  "org_name" => org_name(user)  # NEW
}
```

Add helper `org_name/1` similar to existing `org_tier/1`:
```elixir
defp org_name(user) do
  case user do
    %{organization: %{name: name}} when not is_nil(name) -> name
    _ -> nil
  end
end
```

Ensure organization is preloaded in both code paths (it already is for `org_tier`).

### Phase 3: Hub Backend — Add Proxy Routes (sertantai-hub)

**File**: `backend/lib/sertantai_hub_web/controllers/auth_proxy_controller.ex`

Add two new functions:
```elixir
def organization_show(conn, _params) do
  proxy_get(conn, "/api/organization", auth_header(conn))
end

def organization_update(conn, params) do
  proxy_patch(conn, "/api/organization", params, auth_header(conn))
end
```

**File**: `backend/lib/sertantai_hub_web/router.ex`

Add to the authenticated auth proxy scope:
```elixir
# Organization management
get("/organization", AuthProxyController, :organization_show)
patch("/organization", AuthProxyController, :organization_update)
```

These sit alongside the existing profile routes in the `api_authenticated` auth proxy scope at `/api/auth/organization`.

**Tests**: Add to `auth_proxy_controller_test.exs` — verify routes exist and proxy correctly.

### Phase 4: Hub Frontend — Organisation Settings Page & Dashboard Update

**New file**: `frontend/src/lib/api/organization.ts`

Follow `profile.ts` pattern:
```typescript
export interface Organization {
  id: string;
  name: string;
  slug: string;
  tier: string;
  settings: Record<string, unknown>;
}

export async function getOrganization(): Promise<{ ok: boolean; data?: Organization; error?: string }>
export async function updateOrganization(params: { name?: string }): Promise<{ ok: boolean; data?: Organization; error?: string }>
```

- `GET /api/auth/organization`
- `PATCH /api/auth/organization` with `{ organization: params }` wrapping

**New file**: `frontend/src/routes/settings/organization/+page.svelte`

Follow `settings/profile/+page.svelte` pattern:
- Views: `loading` | `organization` | `edit`
- Display: org name, slug (read-only), tier (read-only badge)
- Edit: name only
- Back link to `/dashboard`

**Modify**: `frontend/src/lib/stores/auth.ts`

Add `organizationName` to `AuthState`:
```typescript
export interface AuthState {
  // ... existing fields
  organizationName: string | null;  // NEW
}
```

Update `setAuth()`, `initialize()` (read from JWT `org_name` claim), and initial state.

**Modify**: `frontend/src/routes/dashboard/+page.svelte`

1. Change the Organisation card from a `<div>` to an `<a href="/settings/organization">` link
2. Remove `opacity-75` and "Coming Soon" badge
3. Show `$authStore.organizationName` instead of truncated UUID
4. Keep the truncated UUID as secondary info if org name isn't set

**New file**: `frontend/src/lib/api/organization.test.ts` — follow `profile.test.ts` pattern

## Files to Modify

| File | Repo | Action |
|------|------|--------|
| `lib/sertantai_auth_web/controllers/organization_controller.ex` | auth | Create |
| `lib/sertantai_auth_web/router.ex` | auth | Edit (add routes) |
| `lib/sertantai_auth_web/controllers/auth_controller.ex` | auth | Edit (add org_name to JWT) |
| `test/.../organization_controller_test.exs` | auth | Create |
| `backend/.../controllers/auth_proxy_controller.ex` | hub | Edit (add 2 functions) |
| `backend/.../router.ex` | hub | Edit (add 2 routes) |
| `backend/test/.../auth_proxy_controller_test.exs` | hub | Edit (add tests) |
| `frontend/src/lib/api/organization.ts` | hub | Create |
| `frontend/src/lib/api/organization.test.ts` | hub | Create |
| `frontend/src/routes/settings/organization/+page.svelte` | hub | Create |
| `frontend/src/lib/stores/auth.ts` | hub | Edit (add organizationName) |
| `frontend/src/routes/dashboard/+page.svelte` | hub | Edit (activate card) |

## Verification

1. **Auth service tests**: `cd ~/Desktop/sertantai-auth && mix test` — all pass including new org controller tests
2. **Hub backend tests**: `cd ~/Desktop/sertantai-hub/backend && mix test` — all pass including new proxy tests
3. **Hub frontend tests**: `cd ~/Desktop/sertantai-hub/frontend && npm test` — all pass including new org API tests
4. **Manual E2E**: Start dev services, login, navigate to `/settings/organization`, verify org name displays, edit name, confirm dashboard card shows updated name
5. **Deploy**: Build and deploy auth first (JWT change), then hub (frontend + backend)
