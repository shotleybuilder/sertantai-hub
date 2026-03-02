<script lang="ts">
	import { onMount, onDestroy } from 'svelte';
	import { authStore } from '$lib/stores/auth';
	import {
		adminUsersStore,
		adminUsersLoading,
		adminUsersError,
		initAdminUsersSync,
		stopAdminUsersSync
	} from '$lib/stores/admin-users';
	import type { AdminUser } from '$lib/api/admin';

	let search = '';
	let roleFilter = '';

	onMount(() => {
		if ($authStore.organizationId) {
			initAdminUsersSync($authStore.organizationId);
		}
	});

	onDestroy(() => {
		stopAdminUsersSync();
	});

	$: filteredUsers = $adminUsersStore.filter((user: AdminUser) => {
		const matchesSearch =
			!search ||
			user.email.toLowerCase().includes(search.toLowerCase()) ||
			(user.name && user.name.toLowerCase().includes(search.toLowerCase()));
		const matchesRole = !roleFilter || user.role === roleFilter;
		return matchesSearch && matchesRole;
	});

	function roleBadgeClass(role: string): string {
		switch (role) {
			case 'owner':
				return 'bg-purple-100 text-purple-800';
			case 'admin':
				return 'bg-blue-100 text-blue-800';
			case 'member':
				return 'bg-gray-100 text-gray-800';
			case 'viewer':
				return 'bg-gray-100 text-gray-600';
			default:
				return 'bg-gray-100 text-gray-800';
		}
	}

	function formatDate(dateStr: string): string {
		return new Date(dateStr).toLocaleDateString('en-GB', {
			day: 'numeric',
			month: 'short',
			year: 'numeric'
		});
	}
</script>

{#if $adminUsersLoading}
	<div class="text-center py-12">
		<div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
		<p class="text-gray-500 mt-4">Loading users...</p>
	</div>
{:else if $adminUsersError}
	<div class="p-4 bg-red-50 border border-red-200 rounded-md">
		<p class="text-sm text-red-600">{$adminUsersError}</p>
	</div>
{:else}
	<!-- Search and Filter -->
	<div class="flex flex-col sm:flex-row gap-3 mb-6">
		<input
			type="text"
			bind:value={search}
			placeholder="Search by name or email..."
			class="flex-1 rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
		/>
		<select
			bind:value={roleFilter}
			class="rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
		>
			<option value="">All roles</option>
			<option value="owner">Owner</option>
			<option value="admin">Admin</option>
			<option value="member">Member</option>
			<option value="viewer">Viewer</option>
		</select>
	</div>

	<!-- User Count -->
	<p class="text-sm text-gray-500 mb-4">
		{filteredUsers.length} user{filteredUsers.length !== 1 ? 's' : ''}
		{#if search || roleFilter}
			(filtered)
		{/if}
	</p>

	<!-- Users Table -->
	<div class="bg-white rounded-lg shadow overflow-hidden">
		<table class="min-w-full divide-y divide-gray-200">
			<thead class="bg-gray-50">
				<tr>
					<th
						class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
					>
						User
					</th>
					<th
						class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
					>
						Role
					</th>
					<th
						class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
					>
						Status
					</th>
					<th
						class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
					>
						Joined
					</th>
				</tr>
			</thead>
			<tbody class="bg-white divide-y divide-gray-200">
				{#each filteredUsers as user (user.id)}
					<tr>
						<td class="px-6 py-4">
							<a href="/admin/users/{user.id}" class="block hover:bg-gray-50 -mx-6 -my-4 px-6 py-4">
								<div class="text-sm font-medium text-gray-900">
									{user.name || '(no name)'}
								</div>
								<div class="text-sm text-gray-500">{user.email}</div>
							</a>
						</td>
						<td class="px-6 py-4 whitespace-nowrap">
							<span
								class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium {roleBadgeClass(
									user.role
								)}"
							>
								{user.role}
							</span>
						</td>
						<td class="px-6 py-4 whitespace-nowrap">
							{#if user.killed_at}
								<span
									class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800"
								>
									Deactivated
								</span>
							{:else}
								<span
									class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800"
								>
									Active
								</span>
							{/if}
						</td>
						<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
							{formatDate(user.inserted_at)}
						</td>
					</tr>
				{:else}
					<tr>
						<td colspan="4" class="px-6 py-8 text-center text-sm text-gray-500">
							No users found
						</td>
					</tr>
				{/each}
			</tbody>
		</table>
	</div>
{/if}
