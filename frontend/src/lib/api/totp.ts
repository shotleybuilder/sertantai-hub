/**
 * TOTP 2FA API functions
 * Manages setup, enable, disable, and status check for two-factor authentication.
 */

import { apiFetch } from './client';

export interface TotpStatusResponse {
	totp_enabled: boolean;
	enabled_at: string | null;
	backup_codes_remaining: number;
}

export interface TotpSetupResponse {
	status: string;
	secret: string;
	uri: string;
	backup_codes: string[];
}

export interface TotpToggleResponse {
	status: string;
	enabled: boolean;
}

export async function totpStatus(): Promise<{
	ok: boolean;
	data?: TotpStatusResponse;
	error?: string;
}> {
	try {
		const response = await apiFetch('/api/auth/totp/status');
		const data = await response.json();
		if (!response.ok) {
			return { ok: false, error: data.error || data.message || 'Failed to check TOTP status' };
		}
		return { ok: true, data };
	} catch (e) {
		return { ok: false, error: e instanceof Error ? e.message : 'Network error' };
	}
}

export async function totpSetup(): Promise<{
	ok: boolean;
	data?: TotpSetupResponse;
	error?: string;
}> {
	try {
		const response = await apiFetch('/api/auth/totp/setup', { method: 'POST' });
		const data = await response.json();
		if (!response.ok) {
			return { ok: false, error: data.error || data.message || 'Failed to setup TOTP' };
		}
		return { ok: true, data };
	} catch (e) {
		return { ok: false, error: e instanceof Error ? e.message : 'Network error' };
	}
}

export async function totpEnable(
	code: string
): Promise<{ ok: boolean; data?: TotpToggleResponse; error?: string }> {
	try {
		const response = await apiFetch('/api/auth/totp/enable', {
			method: 'POST',
			body: JSON.stringify({ code })
		});
		const data = await response.json();
		if (!response.ok) {
			return { ok: false, error: data.error || data.message || 'Invalid code' };
		}
		return { ok: true, data };
	} catch (e) {
		return { ok: false, error: e instanceof Error ? e.message : 'Network error' };
	}
}

export async function totpDisable(
	code: string
): Promise<{ ok: boolean; data?: TotpToggleResponse; error?: string }> {
	try {
		const response = await apiFetch('/api/auth/totp/disable', {
			method: 'POST',
			body: JSON.stringify({ code })
		});
		const data = await response.json();
		if (!response.ok) {
			return { ok: false, error: data.error || data.message || 'Invalid code' };
		}
		return { ok: true, data };
	} catch (e) {
		return { ok: false, error: e instanceof Error ? e.message : 'Network error' };
	}
}
