# Deployment to Production Server

**Started**: 2026-02-19

## Todo
- [x] Create `deploy-prod.sh` for hub (adapt from legal's version with hub ports/services)
- [x] Fix IMAGE_NAME in all 4 build/push scripts + README.md
- [x] Verify Dockerfiles exist (`backend/Dockerfile`, `frontend/Dockerfile`)
- [x] Test build scripts run without error
- [x] Fix CORS regex sigils in endpoint.ex (broke prod build)
- [x] Fix Dockerfile port 4000 → 4006
- [x] Commit and push (609848f, 68033c2, 6cd842b)
- [x] push-backend.sh and push-frontend.sh tested — images on GHCR

### Infrastructure setup (~/Desktop/infrastructure)
- [x] Add `sertantai_hub_prod` database to `data/postgres-init/01-create-databases.sql`
- [x] Add hub env vars section to `docker/.env.example`
- [x] Add 3 services to `docker/docker-compose.yml` (electric, backend, frontend)
- [x] Update nginx `depends_on` in docker-compose.yml
- [x] Create `nginx/conf.d/hub.sertantai.com.conf`
- [x] Commit and push infrastructure (60ac910)

### Server-side
- [x] Add hub env vars to `docker/.env` (actual secrets)
- [x] Generate SSL certs: sertantai.com + hub.sertantai.com + auth.sertantai.com
- [x] Create sertantai_hub_prod database + extensions
- [x] Deploy hub services (electric, backend, frontend)
- [x] Verify: https://sertantai.com live and serving

### Production fixes during deployment
- [x] Alpine 3.19 → 3.23 (OpenSSL mismatch: crypto.so needs 3.4, Alpine 3.19/3.21 too old)
- [x] Domain changed: sertantai.com (primary) + hub.sertantai.com (alias/redirect)
- [x] Disabled ehs-enforcement.conf (container stopped, nginx couldn't resolve upstream)
- [x] Created auth.sertantai.com SSL cert (needed for hub auth)
- [x] Stopped ehs-enforcement to free postgres connections (108/100 max)

### TODO (follow-up, not blocking)
- [x] Increase postgres max_connections to 200 (2f7960f)
- [ ] Fix deprecated `listen ... http2` nginx directives
- [ ] Properly deploy auth service (separate session in sertantai-auth project)

## Notes
- No GH issue for this session
- Backend image: 157MB (Alpine 3.23), Frontend image: 147MB
- Both images on GHCR, deployed via deploy-prod.sh
- Production URL: https://sertantai.com
- Build fixes during session:
  - CORS `~r{}` regex → string literals (compile-time #Reference error)
  - Dockerfile port 4000 → 4006
  - Frontend Dockerfile GID 1000 conflict → reuse `node` user
  - Runtime Alpine 3.19 → 3.23 (match builder for OpenSSL 3.4)
- Postgres connections tight: 100 max, ~97 in use after stopping ehs-enforcement
- Fixed: max_connections increased to 200 via docker-compose command flag

**Ended**: 2026-02-19
