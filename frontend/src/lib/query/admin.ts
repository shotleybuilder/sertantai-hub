/**
 * TanStack Query hooks for admin operations.
 * Mutations with optimistic updates for role changes, token revocation, and kill/unkill.
 */

import { createQuery, createMutation } from '@tanstack/svelte-query';
import { get } from 'svelte/store';
import { queryClient } from '$lib/query/client';
import { adminUsersStore, updateUserInStore, refreshAdminUsers } from '$lib/stores/admin-users';
import { getUser, changeRole, revokeTokens, killUser, unkillUser } from '$lib/api/admin';
import type { AdminUser, AdminUserDetail } from '$lib/api/admin';

export const adminKeys = {
	users: ['admin', 'users'] as const,
	user: (id: string) => ['admin', 'users', id] as const
};

/**
 * Query for admin user list (reads from ElectricSQL-backed store).
 */
export function useAdminUsersQuery() {
	return createQuery({
		queryKey: adminKeys.users,
		queryFn: () => get(adminUsersStore),
		refetchOnMount: false,
		refetchOnReconnect: false,
		refetchOnWindowFocus: false
	});
}

/**
 * Query for a single user detail (fetches from API for token count).
 */
export function useAdminUserQuery(id: string) {
	return createQuery({
		queryKey: adminKeys.user(id),
		queryFn: async () => {
			const result = await getUser(id);
			if (!result.ok || !result.data) throw new Error(result.error || 'Failed to load user');
			return result.data;
		},
		enabled: !!id
	});
}

/**
 * Mutation to change a user's role with optimistic update.
 */
export function useChangeRoleMutation() {
	return createMutation({
		mutationFn: async ({ id, role }: { id: string; role: string }) => {
			const result = await changeRole(id, role);
			if (!result.ok) throw new Error(result.error || 'Failed to change role');
			return result.data;
		},
		onMutate: async ({ id, role }) => {
			const previousUsers = get(adminUsersStore);
			updateUserInStore(id, { role });
			return { previousUsers };
		},
		onError: (_error: Error, _vars: { id: string; role: string }, context) => {
			if (context?.previousUsers) {
				adminUsersStore.set(context.previousUsers);
			}
		},
		onSettled: () => {
			refreshAdminUsers();
			queryClient?.invalidateQueries({ queryKey: adminKeys.users });
		}
	});
}

/**
 * Mutation to revoke all tokens for a user.
 */
export function useRevokeTokensMutation() {
	return createMutation({
		mutationFn: async (id: string) => {
			const result = await revokeTokens(id);
			if (!result.ok) throw new Error(result.error || 'Failed to revoke tokens');
		},
		onSettled: (_data, _error, id) => {
			queryClient?.invalidateQueries({ queryKey: adminKeys.user(id) });
		}
	});
}

/**
 * Mutation to kill (deactivate) a user with optimistic update.
 */
export function useKillUserMutation() {
	return createMutation({
		mutationFn: async (id: string) => {
			const result = await killUser(id);
			if (!result.ok) throw new Error(result.error || 'Failed to deactivate user');
		},
		onMutate: async (id: string) => {
			const previousUsers = get(adminUsersStore);
			updateUserInStore(id, { killed_at: new Date().toISOString() });
			return { previousUsers };
		},
		onError: (_error: Error, _id: string, context) => {
			if (context?.previousUsers) {
				adminUsersStore.set(context.previousUsers);
			}
		},
		onSettled: (_data, _error, id) => {
			refreshAdminUsers();
			queryClient?.invalidateQueries({ queryKey: adminKeys.user(id) });
		}
	});
}

/**
 * Mutation to unkill (reactivate) a user with optimistic update.
 */
export function useUnkillUserMutation() {
	return createMutation({
		mutationFn: async (id: string) => {
			const result = await unkillUser(id);
			if (!result.ok) throw new Error(result.error || 'Failed to reactivate user');
		},
		onMutate: async (id: string) => {
			const previousUsers = get(adminUsersStore);
			updateUserInStore(id, { killed_at: null });
			return { previousUsers };
		},
		onError: (_error: Error, _id: string, context) => {
			if (context?.previousUsers) {
				adminUsersStore.set(context.previousUsers);
			}
		},
		onSettled: (_data, _error, id) => {
			refreshAdminUsers();
			queryClient?.invalidateQueries({ queryKey: adminKeys.user(id) });
		}
	});
}
