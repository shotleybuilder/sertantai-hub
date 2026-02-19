.PHONY: help setup dev stop migrate rollback seed test test-frontend test-backend lint format build

# Default target
help:
	@echo "SertantAI Hub - Development Commands"
	@echo ""
	@echo "Setup & Development:"
	@echo "  make setup          - Install dependencies for frontend and backend"
	@echo "  make dev            - Start dev servers (thin: hub + auth + containers)"
	@echo "  make dev-thick      - Start full micro-services stack"
	@echo "  make stop           - Stop hub servers"
	@echo "  make stop-all       - Stop hub + all micro-services"
	@echo ""
	@echo "Database:"
	@echo "  make migrate        - Run database migrations (Ash)"
	@echo "  make rollback       - Rollback last migration"
	@echo "  make seed           - Seed database with test data"
	@echo ""
	@echo "Testing:"
	@echo "  make test           - Run all tests"
	@echo "  make test-frontend  - Run frontend tests"
	@echo "  make test-backend   - Run backend tests"
	@echo ""
	@echo "Code Quality:"
	@echo "  make lint           - Run all linters"
	@echo "  make format         - Format all code"
	@echo ""
	@echo "Production:"
	@echo "  make build          - Build production artifacts"
	@echo ""
	@echo "Scripts (recommended):"
	@echo "  sert-hub-start --docker --auth     - Thin test"
	@echo "  sert-hub-start --docker --thick    - Thick test (all services)"
	@echo "  sert-hub-stop                      - Stop hub"
	@echo "  sert-hub-restart --frontend        - Restart frontend only"

# Install dependencies
setup:
	@echo "Installing frontend dependencies..."
	cd frontend && npm install
	@echo "Installing backend dependencies..."
	cd backend && mix deps.get
	@echo "Setup complete!"

# Start development environment (thin: hub + auth + containers)
dev:
	./scripts/development/sert-hub-start --docker --auth

# Start full micro-services stack (thick test)
dev-thick:
	./scripts/development/sert-hub-start --docker --thick

# Stop hub services
stop:
	./scripts/development/sert-hub-stop

# Stop all services including micro-services
stop-all:
	./scripts/development/sert-hub-stop --docker --thick

# Run database migrations (use Ash generators, not plain Ecto)
migrate:
	@echo "Running database migrations..."
	cd backend && mix ash_postgres.migrate

# Rollback last migration
rollback:
	@echo "Rolling back last migration..."
	cd backend && mix ecto.rollback

# Seed database
seed:
	@echo "Seeding database..."
	cd backend && mix run priv/repo/seeds.exs

# Run all tests
test: test-backend test-frontend
	@echo "All tests complete!"

# Run frontend tests
test-frontend:
	@echo "Running frontend tests..."
	cd frontend && npm run test

# Run backend tests
test-backend:
	@echo "Running backend tests..."
	cd backend && mix test

# Run linters
lint:
	@echo "Running linters..."
	@echo "Linting frontend..."
	cd frontend && npm run lint
	@echo "Linting backend..."
	cd backend && mix credo

# Format code
format:
	@echo "Formatting code..."
	@echo "Formatting frontend..."
	cd frontend && npm run format
	@echo "Formatting backend..."
	cd backend && mix format

# Build production artifacts
build:
	@echo "Building production artifacts..."
	@echo "Building frontend..."
	cd frontend && npm run build
	@echo "Building backend..."
	cd backend && MIX_ENV=prod mix release
	@echo "Build complete!"
