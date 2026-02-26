/**
 * Subscription CRUD API functions
 * Manages law change notification subscriptions.
 */

import { apiFetch } from './client';
import type {
	Subscription,
	LawChangeEvent,
	CreateSubscriptionParams,
	UpdateSubscriptionParams
} from '$lib/types/notifications';

export async function listSubscriptions(): Promise<{
	ok: boolean;
	data?: Subscription[];
	error?: string;
}> {
	try {
		const response = await apiFetch('/api/subscriptions');
		const json = await response.json();
		if (!response.ok) {
			return { ok: false, error: json.error || 'Failed to load subscriptions' };
		}
		return { ok: true, data: json.data };
	} catch (e) {
		return { ok: false, error: e instanceof Error ? e.message : 'Network error' };
	}
}

export async function getSubscription(
	id: string
): Promise<{ ok: boolean; data?: Subscription; error?: string }> {
	try {
		const response = await apiFetch(`/api/subscriptions/${id}`);
		const json = await response.json();
		if (!response.ok) {
			return { ok: false, error: json.error || 'Subscription not found' };
		}
		return { ok: true, data: json.data };
	} catch (e) {
		return { ok: false, error: e instanceof Error ? e.message : 'Network error' };
	}
}

export async function createSubscription(
	params: CreateSubscriptionParams
): Promise<{ ok: boolean; data?: Subscription; error?: string }> {
	try {
		const response = await apiFetch('/api/subscriptions', {
			method: 'POST',
			body: JSON.stringify(params)
		});
		const json = await response.json();
		if (!response.ok) {
			const errorMsg = Array.isArray(json.error)
				? json.error.map((e: { message: string }) => e.message).join(', ')
				: json.error || 'Failed to create subscription';
			return { ok: false, error: errorMsg };
		}
		return { ok: true, data: json.data };
	} catch (e) {
		return { ok: false, error: e instanceof Error ? e.message : 'Network error' };
	}
}

export async function updateSubscription(
	id: string,
	params: UpdateSubscriptionParams
): Promise<{ ok: boolean; data?: Subscription; error?: string }> {
	try {
		const response = await apiFetch(`/api/subscriptions/${id}`, {
			method: 'PATCH',
			body: JSON.stringify(params)
		});
		const json = await response.json();
		if (!response.ok) {
			const errorMsg = Array.isArray(json.error)
				? json.error.map((e: { message: string }) => e.message).join(', ')
				: json.error || 'Failed to update subscription';
			return { ok: false, error: errorMsg };
		}
		return { ok: true, data: json.data };
	} catch (e) {
		return { ok: false, error: e instanceof Error ? e.message : 'Network error' };
	}
}

export async function deleteSubscription(id: string): Promise<{ ok: boolean; error?: string }> {
	try {
		const response = await apiFetch(`/api/subscriptions/${id}`, {
			method: 'DELETE'
		});
		if (!response.ok) {
			const json = await response.json();
			return { ok: false, error: json.error || 'Failed to delete subscription' };
		}
		return { ok: true };
	} catch (e) {
		return { ok: false, error: e instanceof Error ? e.message : 'Network error' };
	}
}

export async function listEvents(): Promise<{
	ok: boolean;
	data?: LawChangeEvent[];
	error?: string;
}> {
	try {
		const response = await apiFetch('/api/notification-events');
		const json = await response.json();
		if (!response.ok) {
			return { ok: false, error: json.error || 'Failed to load events' };
		}
		return { ok: true, data: json.data };
	} catch (e) {
		return { ok: false, error: e instanceof Error ? e.message : 'Network error' };
	}
}
