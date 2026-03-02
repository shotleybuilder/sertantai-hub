/**
 * Admin users store
 * Backed by ElectricSQL ShapeStream for real-time sync of org users.
 * Falls back to REST API if ElectricSQL is unavailable.
 */

import { writable } from 'svelte/store';
import type { AdminUser } from '$lib/api/admin';
import { listUsers } from '$lib/api/admin';

const ELECTRIC_URL = import.meta.env.VITE_ELECTRIC_URL || 'http://localhost:3000';

export const adminUsersStore = writable<AdminUser[]>([]);
export const adminUsersLoading = writable<boolean>(false);
export const adminUsersError = writable<string | null>(null);

let shapeStream: EventSource | null = null;

/**
 * Initialize admin users sync via ElectricSQL ShapeStream.
 * Falls back to REST API fetch if Electric is unavailable.
 */
export async function initAdminUsersSync(organizationId: string): Promise<void> {
	adminUsersLoading.set(true);
	adminUsersError.set(null);

	try {
		// Try ElectricSQL shape stream first
		const shapeUrl = `${ELECTRIC_URL}/v1/shape?table=users&where=organization_id='${organizationId}'`;
		const response = await fetch(shapeUrl, { method: 'GET', signal: AbortSignal.timeout(3000) });

		if (response.ok) {
			// ElectricSQL is available — set up streaming sync
			await setupElectricSync(organizationId);
			return;
		}
	} catch {
		// ElectricSQL unavailable, fall back to REST
	}

	// Fallback: load via REST API
	await loadUsersViaApi();
}

async function setupElectricSync(organizationId: string): Promise<void> {
	stopAdminUsersSync();

	const shapeUrl = `${ELECTRIC_URL}/v1/shape?table=users&where=organization_id='${organizationId}'&offset=-1`;

	try {
		const { ShapeStream } = await import('@electric-sql/client');
		const stream = new ShapeStream({
			url: `${ELECTRIC_URL}/v1/shape`,
			params: {
				table: 'users',
				where: `organization_id='${organizationId}'`
			}
		});

		const users = new Map<string, AdminUser>();

		// eslint-disable-next-line @typescript-eslint/no-explicit-any
		stream.subscribe((messages: any[]) => {
			let changed = false;

			for (const msg of messages) {
				if ('headers' in msg && !('value' in msg)) continue;

				const key = msg.key as string | undefined;
				if (msg.headers?.operation === 'delete') {
					if (key && users.has(key)) {
						users.delete(key);
						changed = true;
					}
				} else if (msg.value) {
					const value = msg.value as Record<string, string>;
					const user: AdminUser = {
						id: value.id,
						email: value.email,
						name: value.name || null,
						role: value.role || 'member',
						killed_at: value.killed_at || null,
						inserted_at: value.inserted_at,
						updated_at: value.updated_at
					};
					users.set(key || user.id, user);
					changed = true;
				}
			}

			if (changed) {
				adminUsersStore.set(Array.from(users.values()));
				adminUsersLoading.set(false);
			}
		});
	} catch {
		// If ShapeStream fails, fallback to REST
		await loadUsersViaApi();
	}
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
 * Stop the ElectricSQL sync stream.
 */
export function stopAdminUsersSync(): void {
	if (shapeStream) {
		shapeStream.close();
		shapeStream = null;
	}
}
