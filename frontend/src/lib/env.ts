/**
 * Runtime environment helper.
 *
 * In Docker containers, VITE_* env vars are injected at startup into
 * window.__ENV__ via docker-entrypoint.sh. This lets one image work
 * for both production and local dev — the compose file sets the URLs.
 *
 * When running `npm run dev` outside Docker, falls back to Vite's
 * build-time import.meta.env (reads .env.development).
 */

declare global {
	interface Window {
		__ENV__?: Record<string, string>;
	}
}

function env(key: string): string | undefined {
	if (typeof window !== 'undefined' && window.__ENV__?.[key]) {
		return window.__ENV__[key];
	}
	return import.meta.env[key];
}

export const API_URL = env('VITE_API_URL') || 'http://localhost:4006';
export const LEGAL_URL = env('VITE_LEGAL_URL') || 'http://localhost:5175';
export const ENFORCEMENT_URL = env('VITE_ENFORCEMENT_URL') || 'http://localhost:5174';
export const COMPLIANCE_URL = env('VITE_COMPLIANCE_URL') || 'http://localhost:5176';
// Controls moved to 5177 when compliance took 5176 (README port allocation)
export const CONTROLS_URL = env('VITE_CONTROLS_URL') || 'http://localhost:5177';
