# Plan: Auth Service Health Check & Deploy Integration

## Context

sertantai-hub has a strong runtime dependency on sertantai-auth:
- **JwksClient** fetches EdDSA public key from `{AUTH_URL}/.well-known/jwks.json` on startup (retries every 30s if down)
- **AuthProxyController** proxies all login/register/TOTP requests to `{AUTH_SERVICE_URL}`

If auth is down, hub can start but: JWT validation fails (no public key), all auth API calls return 502. The current `/health/detailed` endpoint only checks database — it has no visibility into auth connectivity. The deploy script (`deploy-prod.sh`) has no awareness of auth at all.

Both services run on the same production server (`sertantai-hz`) in `~/infrastructure/docker`. Auth is a separate docker-compose service (`sertantai-auth`) managed in a different project, but co-located on the same server.

**Startup order**: Auth should be running before hub starts, because hub's JwksClient needs the JWKS endpoint immediately. If auth isn't ready, JwksClient retries every 30s (graceful degradation), but auth proxy calls will 502 until auth is up.

## Changes

### 1. Add auth service check to `/health/detailed`

**File**: `backend/lib/sertantai_hub_web/controllers/health_controller.ex`

Add a new `check_auth_service/0` function alongside existing `check_database/0` and `check_application/0`. This checks two things:
- **JWKS key cached**: Does `JwksClient.public_key()` return `{:ok, _}`? (Has the key been fetched successfully at least once?)
- **Auth service reachable**: HTTP GET to `{AUTH_SERVICE_URL}/health` with a short timeout (2s). This confirms the auth proxy path works.

Add to the `checks` map:
```elixir
checks: %{
  database: check_database(),
  application: check_application(),
  auth_service: check_auth_service()
}
```

The existing `all_checks_healthy?/1` logic already iterates all checks, so auth being down will cause `/health/detailed` to return 503.

### 2. Add auth awareness to `deploy-prod.sh`

**File**: `scripts/deployment/deploy-prod.sh`

Add configuration for auth service:
```bash
AUTH_CONTAINER="sertantai_auth_app"
AUTH_COMPOSE_SERVICE="sertantai-auth"
AUTH_HEALTH_URL="http://localhost:4001/health"  # internal port
```

Add new CLI options:
- `--check-auth` — Check if auth container is running and healthy (included in `--check-only` automatically)
- `--start-auth` — Start/restart the auth container before deploying hub backend
- `--with-auth` — Alias: check auth health, start if needed, then deploy hub

Changes to existing flows:
- **`--check-only`**: Add auth container status and health check alongside existing backend/frontend/electric checks
- **Backend deploy section**: Before pulling/restarting hub backend, optionally check auth health and warn if auth is not healthy (doesn't block deploy unless `--with-auth` is used)
- **Post-deploy health check**: After hub backend comes up healthy, also verify auth connectivity via hub's `/health/detailed` endpoint

Add a reusable function:
```bash
check_auth_health() {
    # Check container is running
    AUTH_STATUS=$(ssh "${SERVER}" "docker inspect --format='{{.State.Health.Status}}' ${AUTH_CONTAINER}" 2>/dev/null || echo "not_found")
    
    if [ "$AUTH_STATUS" = "healthy" ]; then
        echo -e "${GREEN}✓ Auth service is healthy${NC}"
        return 0
    elif [ "$AUTH_STATUS" = "not_found" ]; then
        echo -e "${RED}✗ Auth container not found${NC}"
        return 1
    else
        echo -e "${YELLOW}⚠ Auth health status: ${AUTH_STATUS}${NC}"
        return 1
    fi
}

start_auth_service() {
    echo -e "${BLUE}Starting auth service...${NC}"
    ssh "${SERVER}" "cd ${DEPLOY_PATH} && docker compose up -d ${AUTH_COMPOSE_SERVICE}"
    # Wait for healthy (up to 30s)
    for i in 1 2 3 4 5 6; do
        sleep 5
        if check_auth_health > /dev/null 2>&1; then
            echo -e "${GREEN}✓ Auth service started and healthy${NC}"
            return 0
        fi
        echo -e "${YELLOW}  Attempt ${i}/6: waiting for auth...${NC}"
    done
    echo -e "${RED}✗ Auth service did not become healthy in 30s${NC}"
    return 1
}
```

### 3. Update `--help` output

Add auth-related options to the help text and the "Production Details" section showing auth container/service names.

## Files to modify

| File | Change |
|------|--------|
| `backend/lib/sertantai_hub_web/controllers/health_controller.ex` | Add `check_auth_service/0` to detailed health |
| `scripts/deployment/deploy-prod.sh` | Add `--check-auth`, `--start-auth`, `--with-auth` options; add auth to `--check-only`; add auth health functions |

## Verification

1. **Health endpoint**: `curl localhost:4006/health/detailed` — should show `auth_service` check with `jwks_cached` and `reachable` status
2. **Deploy check**: `./scripts/deployment/deploy-prod.sh --check-only` — should show auth container status
3. **Deploy with auth**: `./scripts/deployment/deploy-prod.sh --backend --with-auth` — should check/start auth before deploying hub
4. Backend tests: `mix test` still passes (health controller tests may need updating if they exist)
