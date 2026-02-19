# Dev Scripts: Thin & Thick Testing

**Started**: 2026-02-19

## Todo
- [x] Explore existing scripts in hub and legal repos
- [x] Design thin test script (hub + auth + containers)
- [x] Design thick test script (full micro-services stack)
- [x] Implement sert-hub-start (thin + thick modes)
- [x] Implement sert-hub-stop (with --thick flag)
- [x] Implement sert-hub-restart (with --frontend/--backend/--force)
- [x] Fix Makefile (stale ports, wrong project name, wrong commands)
- [x] Replace old dev-start/dev-stop with wrappers

## Notes
- Thin: hub frontend + hub backend + auth service + postgres/electric containers
- Thick: thin + legal + enforcement + controls (full stack)
- Follows sert-legal-* script patterns (gnome-terminal tabs, health checks, flags)
- Thick mode delegates to each service's own start/stop script if available
- Auth project dir: ~/Desktop/sertantai-auth (hyphen, not underscore - legal script has bug)
- Port allocation: Hub 4006/5173, Auth 4000, Legal 4003/5175, Enforcement 4001/5174

## Files
- scripts/development/sert-hub-start (new)
- scripts/development/sert-hub-stop (new)
- scripts/development/sert-hub-restart (new)
- scripts/development/dev-start (replaced with wrapper)
- scripts/development/dev-stop (replaced with wrapper)
- scripts/development/README.md (rewritten)
- Makefile (fixed ports, project name, added dev/dev-thick/stop-all targets)
