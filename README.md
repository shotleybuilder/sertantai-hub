# SertantAI Hub

Central hub of the SertantAI microservices architecture. Built with Elixir + Ash + ElectricSQL + Svelte + TanStack for real-time, offline-first applications.

## Architecture Overview

SertantAI is a microservices ecosystem where each service is a local-first application using ElectricSQL for real-time sync. The Hub serves as the central coordination point.

```
                    ┌─────────────────┐
                    │  SertantAI Hub  │
                    │   (This Repo)   │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐───────────────────┐
        │                    │                    │                   │
        ▼                    ▼                   ▼                   ▼
┌───────────────┐  ┌───────────────┐  ┌───────────────┐  ┌───────────────┐
│ sertantai-auth│  │sertantai-legal│  │sertantai-     │  │sertantai-     │
│               │  │               │  │ enforcement   │  │ controls      │
└───────────────┘  └───────────────┘  └───────────────┘  └───────────────┘
```

### Services

| Service | Purpose |
|---------|---------|
| **sertantai-hub** | Central hub and coordination |
| **sertantai-auth** | Authentication and authorization |
| **sertantai-legal** | Legal document management |
| **sertantai-enforcement** | Enforcement workflows |
| **sertantai-controls** | Control management |

All services share the same tech stack and local-first architecture pattern.

### Port Allocations (Local Development)

Each service uses unique ports to allow running multiple services simultaneously:

| Service | PostgreSQL | Electric | Backend | Frontend |
|---------|------------|----------|---------|----------|
| **hub** | 5435 | 3000 | 4006 | 5173 |
| **enforcement** | 5434 | 3001 | 4002 | 5174 |
| **legal** | 5436 | 3002 | 4003 | 5175 |
| **controls** | 5437 | 3003 | 4004 | 5176 |
| **auth** | 5438 | — | 4000 | — |

## Tech Stack

**Backend:**
- [Elixir](https://elixir-lang.org/) 1.16+ / Erlang OTP 26+
- [Phoenix Framework](https://phoenixframework.org/) 1.7+
- [Ash Framework](https://hexdocs.pm/ash) 3.0+ (declarative resource framework)
- PostgreSQL 15+ with logical replication
- [ElectricSQL](https://electric-sql.com) v1.0 (real-time sync via HTTP Shape API)

**Frontend:**
- [SvelteKit](https://kit.svelte.dev/) (TypeScript)
- [TailwindCSS](https://tailwindcss.com) v4
- [TanStack Query](https://tanstack.com/query) v5 (reactive queries and caching)
- [TanStack DB](https://tanstack.com/db) v0.5 (client-side persistence)
- Vitest (unit testing)

**DevOps:**
- Docker Compose (local development)
- Git hooks (pre-commit: formatting, linting; pre-push: tests, type checking)
- GitHub Actions CI/CD
- Health check endpoints

## Features

- Real-time data synchronization (PostgreSQL <-> ElectricSQL <-> TanStack DB)
- Offline-first with optimistic updates
- Multi-tenant architecture (organization-scoped data)
- Auth-ready (User/Organization resources for JWT validation)
- Comprehensive quality tooling (Credo, Dialyzer, Sobelow, ESLint, Prettier)
- Production-ready Docker setup
- Health monitoring endpoints
- CORS configured for frontend/backend separation

## Quick Start

### Prerequisites

- Docker & Docker Compose
- Elixir 1.16+ / Erlang OTP 26+
- Node.js 20+
- PostgreSQL 15+ (or use Docker)

### 1. Clone & Setup

```bash
git clone <your-repo-url> sertantai-hub
cd sertantai-hub

# Install git hooks (optional but recommended)
./.githooks/setup.sh

# Backend setup
cd backend
mix deps.get
mix ash_postgres.create
mix ash_postgres.migrate
mix run priv/repo/seeds.exs

# Frontend setup
cd ../frontend
npm install

# Start development servers
cd ..
docker-compose -f docker-compose.dev.yml up -d  # PostgreSQL + ElectricSQL
cd backend && mix phx.server &                   # Backend on :4006
cd frontend && npm run dev                       # Frontend on :5173
```

### 2. Verify Setup

- Backend API: http://localhost:4006/health
- Frontend: http://localhost:5173
- ElectricSQL: http://localhost:3000

## Project Structure

```
sertantai-hub/
├── backend/                       # Phoenix + Ash backend
│   ├── lib/
│   │   ├── starter_app/
│   │   │   ├── auth/              # User & Organization resources
│   │   │   ├── api.ex             # Ash Domain
│   │   │   ├── repo.ex            # Ecto Repo
│   │   │   └── application.ex     # OTP Application
│   │   ├── starter_app_web/
│   │   │   ├── controllers/
│   │   │   ├── endpoint.ex
│   │   │   └── router.ex
│   │   └── starter_app.ex
│   ├── priv/
│   │   └── repo/
│   │       ├── migrations/        # Ash-generated migrations
│   │       └── seeds.exs          # Seed data
│   ├── config/                    # Configuration files
│   └── mix.exs
│
├── frontend/                      # SvelteKit frontend
│   ├── src/
│   │   ├── routes/                # SvelteKit routes
│   │   │   ├── +layout.svelte
│   │   │   └── +page.svelte
│   │   └── lib/                   # Shared utilities
│   ├── static/
│   ├── package.json
│   └── vite.config.ts
│
├── scripts/
│   └── deployment/                # Deployment scripts
│
├── .github/
│   └── workflows/
│       └── ci.yml                 # GitHub Actions CI/CD
│
└── docker-compose.dev.yml         # Local development setup
```

## Development

### Common Commands

```bash
# Backend
cd backend
mix deps.get              # Install dependencies
mix ash_postgres.create   # Create database
mix ash_postgres.migrate  # Run migrations
mix run priv/repo/seeds.exs  # Seed database
mix phx.server           # Start server
mix test                 # Run tests
mix credo                # Static analysis
mix dialyzer             # Type checking
mix sobelow              # Security analysis

# Frontend
cd frontend
npm install              # Install dependencies
npm run dev              # Start dev server
npm run build            # Production build
npm run test             # Unit tests
npm run lint             # ESLint
npm run check            # TypeScript check
```

### Environment Variables

**Backend** (`backend/.env`):
```bash
DATABASE_URL=postgresql://postgres:postgres@localhost:5435/starter_app_dev
SECRET_KEY_BASE=your-secret-key-here
FRONTEND_URL=http://localhost:5173
```

**Frontend** (`frontend/.env`):
```bash
VITE_API_URL=http://localhost:4006
PUBLIC_ELECTRIC_URL=http://localhost:3000
```

## Data Flow Architecture

```
PostgreSQL (source of truth)
    ↓ (logical replication)
ElectricSQL (sync service)
    ↓ (HTTP Shape API)
TanStack DB (client persistence)
    ↓ (reactive state)
Svelte Stores (reactivity bridge)
    ↓ (query functions)
TanStack Query (caching & loading states)
    ↓ (reactive UI updates)
Svelte UI (components)
```

### Multi-Tenancy

All data is scoped by `organization_id`. ElectricSQL shapes can be filtered by organization for secure multi-tenant sync.

### Authentication Flow

1. User authenticates via sertantai-auth -> Backend generates JWT
2. JWT includes user_id, organization_id, and authorized shapes
3. Frontend requests shapes with JWT
4. ElectricSQL validates JWT and filters data by organization
5. TanStack DB stores synced data locally
6. UI reacts to local data changes

## Testing

### Backend
```bash
cd backend
mix test                    # All tests
mix test --cover            # With coverage
mix dialyzer                # Type checking
mix credo                   # Static analysis
mix sobelow                 # Security analysis
```

### Frontend
```bash
cd frontend
npm run test                # Unit tests (Vitest)
npm run test:coverage       # With coverage
npm run lint                # ESLint
npm run check               # TypeScript
npm run build               # Production build
```

## Deployment

This template follows a **centralized infrastructure pattern** where PostgreSQL, Redis, Nginx, and SSL are provided by your infrastructure setup.

### Quick Deployment

```bash
# 1. Build Docker images
./scripts/deployment/build-backend.sh
./scripts/deployment/build-frontend.sh

# 2. Push to GitHub Container Registry
./scripts/deployment/push-backend.sh
./scripts/deployment/push-frontend.sh

# 3. Deploy via your infrastructure
# See scripts/deployment/README.md for complete guide
```

### Health Checks

**Backend:**
```bash
curl http://localhost:4006/health
# {"status": "ok", "service": "starter-app", "timestamp": "..."}

curl http://localhost:4006/health/detailed
# Includes database connectivity check
```

**Frontend:**
```bash
curl http://localhost:3000/
# Returns HTML (200 OK)
```

## Related Services

- [sertantai-auth](https://github.com/your-org/sertantai-auth) - Authentication service
- [sertantai-legal](https://github.com/your-org/sertantai-legal) - Legal document management
- [sertantai-enforcement](https://github.com/your-org/sertantai-enforcement) - Enforcement workflows
- [sertantai-controls](https://github.com/your-org/sertantai-controls) - Control management

## Learn More

- [Ash Framework](https://hexdocs.pm/ash) - Declarative resource framework
- [ElectricSQL](https://electric-sql.com) - Real-time sync
- [TanStack DB](https://tanstack.com/db) - Client-side data layer
- [Phoenix Framework](https://phoenixframework.org) - Web framework
- [SvelteKit](https://kit.svelte.dev) - Frontend framework

## License

[MIT License](LICENSE)
