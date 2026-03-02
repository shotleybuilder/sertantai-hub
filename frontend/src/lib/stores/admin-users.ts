/**
 * Admin users store
 * Fetches user data via REST API (proxied to auth service).
 */

import { writable } from 'svelte/store';
import type { AdminUser } from '$lib/api/admin';
import { listUsers } from '$lib/api/admin';

export const adminUsersStore = writable<AdminUser[]>([]);
export const adminUsersLoading = writable<boolean>(false);
export const adminUsersError = writable<string | null>(null);

/**
 * Load admin users via REST API.
 */
export async function initAdminUsersSync(_organizationId: string): Promise<void> {
	adminUsersLoading.set(true);
	adminUsersError.set(null);
	await loadUsersViaApi();
}

async function loadUsersViaApi(): Promise<void> {
	const result = await listUsers();
	if (result.ok && result.data) {
		adminUsersStore.set(result.data);
	} else {
		adminUsersError.set(result.error || 'Failed to load users');
	}
	adminUsersLoading.set(false);
}

/**
 * Refresh users from the REST API (useful after mutations).
 */
export async function refreshAdminUsers(): Promise<void> {
	await loadUsersViaApi();
}

/**
 * Update a single user in the store (for optimistic updates).
 */
export function updateUserInStore(id: string, updates: Partial<AdminUser>): void {
	adminUsersStore.update((users) => users.map((u) => (u.id === id ? { ...u, ...updates } : u)));
}

/**
 * No-op — kept for API compatibility with components that call it.
 */
export function stopAdminUsersSync(): void {
	// No streaming connection to clean up
}
