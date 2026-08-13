// Runtime env injection placeholder.
// In Docker containers, docker-entrypoint.sh overwrites this file
// with window.__ENV__ = { VITE_API_URL: "...", ... };
// For local dev (npm run dev), this file is empty — env.ts falls
// back to import.meta.env which reads .env.development.
