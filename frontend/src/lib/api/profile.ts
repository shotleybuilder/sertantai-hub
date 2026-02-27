/**
 * Profile API functions
 * Manages fetching and updating user profile, and changing password.
 */

import { apiFetch } from './client';

export interface ProfileUser {
	id: string;
	email: string;
	name: string | null;
	role: string;
	organization_id: string;
	confirmed_at: string | null;
}

export interface ProfileResponse {
	status: string;
	user: ProfileUser;
}

export async function getProfile(): Promise<{
	ok: boolean;
	data?: ProfileUser;
	error?: string;
}> {
	try {
		const response = await apiFetch('/api/auth/profile');
		const data = await response.json();
		if (!response.ok) {
			return { ok: false, error: data.error || data.message || 'Failed to fetch profile' };
		}
		return { ok: true, data: data.user };
	} catch (e) {
		return { ok: false, error: e instanceof Error ? e.message : 'Network error' };
	}
}

export async function updateProfile(params: {
	name?: string;
	email?: string;
}): Promise<{ ok: boolean; data?: ProfileUser; error?: string }> {
	try {
		const response = await apiFetch('/api/auth/profile', {
			method: 'PATCH',
			body: JSON.stringify(params)
		});
		const data = await response.json();
		if (!response.ok) {
			return { ok: false, error: data.error || data.message || 'Failed to update profile' };
		}
		return { ok: true, data: data.user };
	} catch (e) {
		return { ok: false, error: e instanceof Error ? e.message : 'Network error' };
	}
}

export async function changePassword(
	currentPassword: string,
	newPassword: string
): Promise<{ ok: boolean; error?: string }> {
	try {
		const response = await apiFetch('/api/auth/profile/change-password', {
			method: 'POST',
			body: JSON.stringify({
				current_password: currentPassword,
				new_password: newPassword
			})
		});
		const data = await response.json();
		if (!response.ok) {
			return { ok: false, error: data.error || data.message || 'Failed to change password' };
		}
		return { ok: true };
	} catch (e) {
		return { ok: false, error: e instanceof Error ? e.message : 'Network error' };
	}
}
