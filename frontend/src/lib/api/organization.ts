/**
 * Organization API functions
 * Manages fetching and updating organization settings.
 */

import { apiFetch } from './client';

export interface Organization {
	id: string;
	name: string;
	slug: string;
	tier: string;
	settings: Record<string, unknown>;
}

export interface OrganizationResponse {
	status: string;
	organization: Organization;
}

export async function getOrganization(): Promise<{
	ok: boolean;
	data?: Organization;
	error?: string;
}> {
	try {
		const response = await apiFetch('/api/auth/organization');
		const data = await response.json();
		if (!response.ok) {
			return { ok: false, error: data.error || data.message || 'Failed to fetch organization' };
		}
		return { ok: true, data: data.organization };
	} catch (e) {
		return { ok: false, error: e instanceof Error ? e.message : 'Network error' };
	}
}

export async function updateOrganization(params: {
	name?: string;
}): Promise<{ ok: boolean; data?: Organization; error?: string }> {
	try {
		const response = await apiFetch('/api/auth/organization', {
			method: 'PATCH',
			body: JSON.stringify({ organization: params })
		});
		const data = await response.json();
		if (!response.ok) {
			return {
				ok: false,
				error: data.error || data.message || 'Failed to update organization'
			};
		}
		return { ok: true, data: data.organization };
	} catch (e) {
		return { ok: false, error: e instanceof Error ? e.message : 'Network error' };
	}
}
