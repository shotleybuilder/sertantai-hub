/**
 * Authenticated fetch wrapper
 * Reads token from auth store, attaches Authorization header.
 * Handles 401 with one refresh retry before clearing auth state.
 */

import { get } from 'svelte/store';
import { authStore, logout, refresh } from '$lib/stores/auth';

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:4006';

interface FetchOptions extends RequestInit {
	skipAuth?: boolean;
}

/**
 * Fetch wrapper that attaches the auth token and handles 401s.
 * On 401, attempts one token refresh and retries the original request.
 * If refresh fails, clears auth state.
 */
export async function apiFetch(path: string, options: FetchOptions = {}): Promise<Response> {
	const { skipAuth, ...fetchOptions } = options;

	function buildHeaders(): Headers {
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
		return headers;
	}

	const response = await fetch(`${API_URL}${path}`, {
		...fetchOptions,
		headers: buildHeaders()
	});

	if (response.status === 401 && !skipAuth) {
		const refreshed = await refresh();
		if (refreshed) {
			// Retry with new token
			return fetch(`${API_URL}${path}`, {
				...fetchOptions,
				headers: buildHeaders()
			});
		}
		logout();
	}

	return response;
}
