/**
 * Admin API client
 * Functions for admin user and organization management.
 * All endpoints require owner or admin role.
 */

import { apiFetch } from '$lib/api/client';

export interface AdminUser {
	id: string;
	email: string;
	name: string | null;
	role: string;
	killed_at: string | null;
	inserted_at: string;
	updated_at: string;
}

export interface AdminUserDetail extends AdminUser {
	active_token_count: number;
}

interface ApiResult<T> {
	ok: boolean;
	data?: T;
	error?: string;
}

export async function listUsers(): Promise<ApiResult<AdminUser[]>> {
	try {
		const response = await apiFetch('/api/admin/users');
		const data = await response.json();
		if (!response.ok) {
			return { ok: false, error: data.message || data.error || 'Failed to list users' };
		}
		return { ok: true, data: data.users };
	} catch (e) {
		return { ok: false, error: e instanceof Error ? e.message : 'Network error' };
	}
}

export async function getUser(id: string): Promise<ApiResult<AdminUserDetail>> {
	try {
		const response = await apiFetch(`/api/admin/users/${id}`);
		const data = await response.json();
		if (!response.ok) {
			return { ok: false, error: data.message || data.error || 'Failed to get user' };
		}
		return { ok: true, data: data.user };
	} catch (e) {
		return { ok: false, error: e instanceof Error ? e.message : 'Network error' };
	}
}

export async function changeRole(id: string, role: string): Promise<ApiResult<AdminUser>> {
	try {
		const response = await apiFetch(`/api/admin/users/${id}/role`, {
			method: 'PATCH',
			body: JSON.stringify({ role })
		});
		const data = await response.json();
		if (!response.ok) {
			return { ok: false, error: data.message || data.error || 'Failed to change role' };
		}
		return { ok: true, data: data.user };
	} catch (e) {
		return { ok: false, error: e instanceof Error ? e.message : 'Network error' };
	}
}

export async function revokeTokens(id: string): Promise<ApiResult<void>> {
	try {
		const response = await apiFetch(`/api/admin/users/${id}/revoke-tokens`, {
			method: 'POST'
		});
		const data = await response.json();
		if (!response.ok) {
			return { ok: false, error: data.message || data.error || 'Failed to revoke tokens' };
		}
		return { ok: true };
	} catch (e) {
		return { ok: false, error: e instanceof Error ? e.message : 'Network error' };
	}
}

export async function killUser(id: string): Promise<ApiResult<void>> {
	try {
		const response = await apiFetch(`/api/admin/users/${id}/kill`, {
			method: 'POST'
		});
		const data = await response.json();
		if (!response.ok) {
			return { ok: false, error: data.message || data.error || 'Failed to deactivate user' };
		}
		return { ok: true };
	} catch (e) {
		return { ok: false, error: e instanceof Error ? e.message : 'Network error' };
	}
}

export async function unkillUser(id: string): Promise<ApiResult<void>> {
	try {
		const response = await apiFetch(`/api/admin/users/${id}/unkill`, {
			method: 'POST'
		});
		const data = await response.json();
		if (!response.ok) {
			return { ok: false, error: data.message || data.error || 'Failed to reactivate user' };
		}
		return { ok: true };
	} catch (e) {
		return { ok: false, error: e instanceof Error ? e.message : 'Network error' };
	}
}
