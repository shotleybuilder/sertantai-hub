# Deployment to Production Server

**Started**: 2026-02-19

## Todo
- [ ] Create `deploy-prod.sh` for hub (adapt from legal's version with hub ports/services)
- [ ] Fix IMAGE_NAME in `build-backend.sh` — replace `YOUR_GITHUB_ORG` with `shotleybuilder`
- [ ] Fix IMAGE_NAME in `build-frontend.sh` — replace `YOUR_GITHUB_ORG` with `shotleybuilder`
- [ ] Fix IMAGE_NAME in `push-backend.sh` — replace `YOUR_GITHUB_ORG` with `shotleybuilder`
- [ ] Fix IMAGE_NAME in `push-frontend.sh` — replace `YOUR_GITHUB_ORG` with `shotleybuilder`
- [ ] Verify Dockerfiles exist (`backend/Dockerfile`, `frontend/Dockerfile`)
- [ ] Test build scripts run without error

## Notes
- No GH issue for this session
- Compared hub vs legal deployment scripts
- Hub missing `deploy-prod.sh` (legal has full SSH deploy orchestrator with --frontend/--backend/--electric modes)
- All 4 hub scripts have placeholder `YOUR_GITHUB_ORG` instead of `shotleybuilder`
- README.md is correct — no fixes needed
- Hub ports: backend 4006, frontend 5173, Electric 3000
- Legal `deploy-prod.sh` reference: `~/Desktop/sertantai-legal/scripts/deployment/deploy-prod.sh`
