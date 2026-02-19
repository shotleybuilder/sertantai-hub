/**
 * Authenticated fetch wrapper
 * Reads token from auth store, attaches Authorization header.
 * Handles 401 by clearing auth state.
 */

import { get } from 'svelte/store';
import { authStore, logout } from '$lib/stores/auth';

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:4006';

interface FetchOptions extends RequestInit {
	skipAuth?: boolean;
}

/**
 * Fetch wrapper that attaches the auth token and handles 401s.
 */
export async function apiFetch(path: string, options: FetchOptions = {}): Promise<Response> {
	const { skipAuth, ...fetchOptions } = options;
	const headers = new Headers(fetchOptions.headers);

	if (!skipAuth) {
		const { token } = get(authStore);
		if (token) {
			headers.set('Authorization', `Bearer ${token}`);
		}
	}

	if (!headers.has('Content-Type') && fetchOptions.body) {
		headers.set('Content-Type', 'application/json');
	}

	const response = await fetch(`${API_URL}${path}`, {
		...fetchOptions,
		headers
	});

	if (response.status === 401 && !skipAuth) {
		logout();
	}

	return response;
}
