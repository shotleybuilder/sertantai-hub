/**
 * Auth state store
 * Manages JWT token, user identity, and auth lifecycle.
 * Persists token to localStorage for session restore.
 */

import { writable, get } from 'svelte/store';
import { decodePayload, isExpired } from '$lib/auth/jwt';

const STORAGE_KEY = 'sertantai_token';
const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:4006';

export interface AuthUser {
	id: string;
	email: string;
}

export interface AuthState {
	token: string | null;
	user: AuthUser | null;
	organizationId: string | null;
	role: string | null;
	isAuthenticated: boolean;
}

const initialState: AuthState = {
	token: null,
	user: null,
	organizationId: null,
	role: null,
	isAuthenticated: false
};

export const authStore = writable<AuthState>(initialState);

/**
 * Set auth state from a token + auth service response.
 */
function setAuth(
	token: string,
	user: { id: string; email: string },
	organizationId: string,
	role: string
) {
	localStorage.setItem(STORAGE_KEY, token);
	authStore.set({
		token,
		user,
		organizationId,
		role,
		isAuthenticated: true
	});
}

function clearAuth() {
	localStorage.removeItem(STORAGE_KEY);
	authStore.set(initialState);
}

/**
 * Register a new user. Auth service auto-creates an organization.
 */
export async function register(
	email: string,
	password: string
): Promise<{ ok: boolean; error?: string }> {
	try {
		const response = await fetch(`${API_URL}/api/auth/register`, {
			method: 'POST',
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify({ user: { email, password } })
		});

		const data = await response.json();

		if (!response.ok) {
			return { ok: false, error: data.error || data.message || 'Registration failed' };
		}

		setAuth(
			data.token,
			{ id: data.user.id, email: data.user.email },
			data.organization_id,
			data.role
		);
		return { ok: true };
	} catch (e) {
		return { ok: false, error: e instanceof Error ? e.message : 'Network error' };
	}
}

/**
 * Login with email and password.
 */
export async function login(
	email: string,
	password: string
): Promise<{ ok: boolean; error?: string }> {
	try {
		const response = await fetch(`${API_URL}/api/auth/login`, {
			method: 'POST',
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify({ user: { email, password } })
		});

		const data = await response.json();

		if (!response.ok) {
			return { ok: false, error: data.error || data.message || 'Login failed' };
		}

		setAuth(
			data.token,
			{ id: data.user.id, email: data.user.email },
			data.organization_id,
			data.role
		);
		return { ok: true };
	} catch (e) {
		return { ok: false, error: e instanceof Error ? e.message : 'Network error' };
	}
}

/**
 * Logout — calls backend, then clears local state regardless.
 */
export async function logout(): Promise<void> {
	const { token } = get(authStore);

	try {
		if (token) {
			await fetch(`${API_URL}/api/auth/logout`, {
				method: 'POST',
				headers: { Authorization: `Bearer ${token}` }
			});
		}
	} catch {
		// Clear state even if backend call fails
	}

	clearAuth();
}

/**
 * Refresh the access token.
 */
export async function refresh(): Promise<boolean> {
	const { token } = get(authStore);
	if (!token) return false;

	try {
		const response = await fetch(`${API_URL}/api/auth/refresh`, {
			method: 'POST',
			headers: { Authorization: `Bearer ${token}` }
		});

		if (!response.ok) {
			clearAuth();
			return false;
		}

		const data = await response.json();
		setAuth(
			data.token,
			{ id: data.user.id, email: data.user.email },
			data.organization_id,
			data.role
		);
		return true;
	} catch {
		clearAuth();
		return false;
	}
}

/**
 * Restore auth state from localStorage on app init.
 * If token is expired, clears it. If near expiry, refreshes.
 */
export async function initialize(): Promise<void> {
	if (typeof window === 'undefined') return;

	const token = localStorage.getItem(STORAGE_KEY);
	if (!token) return;

	if (isExpired(token)) {
		clearAuth();
		return;
	}

	// Restore from token claims
	const payload = decodePayload(token);
	if (!payload) {
		clearAuth();
		return;
	}

	authStore.set({
		token,
		user: { id: payload.sub, email: payload.email || '' },
		organizationId: payload.org_id || payload.organization_id || null,
		role: payload.role || null,
		isAuthenticated: true
	});

	// If within 5 minutes of expiry, proactively refresh
	if (isExpired(token, 5 * 60 * 1000)) {
		await refresh();
	}
}
