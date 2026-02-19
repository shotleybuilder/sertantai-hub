# SertantAI Hub - Development Scripts

Scripts for managing the hub development environment. Supports **thin testing** (hub only) and **thick testing** (full micro-services stack).

## Scripts

| Script | Purpose |
|--------|---------|
| `sert-hub-start` | Start hub dev servers (backend + frontend) |
| `sert-hub-stop` | Stop hub dev servers |
| `sert-hub-restart` | Restart servers (with graceful shutdown) |
| `dev-start` | Legacy wrapper (calls `sert-hub-start --docker --auth`) |
| `dev-stop` | Legacy wrapper (calls `sert-hub-stop`) |

## Quick Start

```bash
# Thin test: hub + auth + Docker containers
sert-hub-start --docker --auth

# Thick test: full micro-services stack
sert-hub-start --docker --thick

# Stop hub
sert-hub-stop

# Stop everything
sert-hub-stop --docker --thick
```

## Symlink Setup

Install scripts globally so they can be run from anywhere:

```bash
sudo ln -sf $(pwd)/scripts/development/sert-hub-start /usr/local/bin/sert-hub-start
sudo ln -sf $(pwd)/scripts/development/sert-hub-stop /usr/local/bin/sert-hub-stop
sudo ln -sf $(pwd)/scripts/development/sert-hub-restart /usr/local/bin/sert-hub-restart
```

## Usage

### sert-hub-start

```bash
sert-hub-start                          # Hub servers only (assumes Docker + auth running)
sert-hub-start --docker                 # Start Docker containers + hub servers
sert-hub-start --auth                   # Also ensure sertantai-auth is running
sert-hub-start --docker --auth          # Thin test (recommended for hub dev)
sert-hub-start --legal                  # Also start sertantai-legal
sert-hub-start --enforcement            # Also start sertantai-enforcement
sert-hub-start --thick                  # Thick test: hub + auth + all micro-services
sert-hub-start --docker --thick         # Full stack with Docker containers
```

### sert-hub-stop

```bash
sert-hub-stop                           # Stop hub servers only
sert-hub-stop --docker                  # Stop hub servers + Docker containers
sert-hub-stop --auth                    # Also stop sertantai-auth
sert-hub-stop --thick                   # Stop hub + all micro-services
sert-hub-stop --docker --thick          # Stop absolutely everything
```

### sert-hub-restart

```bash
sert-hub-restart                        # Restart all hub servers
sert-hub-restart --frontend             # Restart only frontend
sert-hub-restart --backend              # Restart only backend
sert-hub-restart --docker               # Restart with Docker containers
sert-hub-restart --auth                 # Also manage sertantai-auth
sert-hub-restart --force                # Force kill (skip graceful shutdown)
sert-hub-restart --thick                # Restart hub + auth
```

## Testing Modes

### Thin Test (hub development)

Minimum stack for developing hub features:

```
Docker containers:
  - PostgreSQL (port 5435)
  - ElectricSQL (port 3000)

Services:
  - sertantai-auth (port 4000) - authentication
  - sertantai-hub backend (port 4006) - Phoenix/Ash
  - sertantai-hub frontend (port 5173) - SvelteKit
```

### Thick Test (integration testing)

Full micro-services stack for end-to-end testing:

```
Thin test stack, plus:
  - sertantai-legal backend (port 4003) + frontend (port 5175)
  - sertantai-enforcement backend (port 4001) + frontend (port 5174)
  - (sertantai-controls - not yet available)
```

## Port Allocation

| Service | Backend | Frontend | Database | Electric |
|---------|---------|----------|----------|----------|
| Hub | 4006 | 5173 | 5435 | 3000 |
| Auth | 4000 | - | 5435 | - |
| Legal | 4003 | 5175 | 5436 | 3002 |
| Enforcement | 4001 | 5174 | - | - |

## Prerequisites

- **gnome-terminal** (Ubuntu default)
- **Docker** + **docker compose**
- **Elixir/Erlang** for Phoenix backend
- **Node.js/npm** for SvelteKit frontend
- Service repos at `~/Desktop/sertantai-{auth,legal,enforcement}`

## Makefile

The Makefile provides additional convenience targets:

```bash
make dev          # Same as sert-hub-start --docker --auth
make dev-thick    # Same as sert-hub-start --docker --thick
make stop         # Same as sert-hub-stop
make stop-all     # Same as sert-hub-stop --docker --thick
make test         # Run all tests
make lint         # Run all linters
make setup        # Install all dependencies
```
