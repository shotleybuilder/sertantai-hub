# Dashboard Updates

**Started**: 2026-02-19

## Todo
- [x] Make service tiles clickable links to their apps
- [x] Create `ServiceTile.svelte` component with health check + tier badge
- [x] Rewrite dashboard with `ServiceTile` components + subscription mock data
- [x] Add account admin stubs (Profile, Organization, Billing, Team Members)
- [x] Verify: `npm run check` + `npm run build`

## Notes
- No GH issue for this session
- Clickable tiles done in previous context
- Plan approved: dashboard evolution with health status, per-service subscription badges, account admin stubs
- Subscription tiers: Blanket Bog (free), Flower Meadow (standard), Atlantic Rainforest (premium)
- Health endpoints: Legal :4003/health, Enforcement :4001/health, Controls :4004/health
- Tier data stubbed/mocked for now — no backend subscription support yet
- Legal tile links to /browse (not /)

**Ended**: 2026-02-19
