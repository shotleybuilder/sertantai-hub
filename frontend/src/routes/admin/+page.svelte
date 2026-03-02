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

	onMount(() => {
		if ($authStore.organizationId) {
			initAdminUsersSync($authStore.organizationId);
		}
	});

	onDestroy(() => {
		stopAdminUsersSync();
	});

	$: users = $adminUsersStore;
	$: ownerCount = users.filter((u) => u.role === 'owner').length;
	$: adminCount = users.filter((u) => u.role === 'admin').length;
	$: memberCount = users.filter((u) => u.role === 'member').length;
	$: viewerCount = users.filter((u) => u.role === 'viewer').length;
	$: activeCount = users.filter((u) => !u.killed_at).length;
	$: deactivatedCount = users.filter((u) => u.killed_at).length;
</script>

{#if $adminUsersLoading}
	<div class="text-center py-12">
		<div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
		<p class="text-gray-500 mt-4">Loading...</p>
	</div>
{:else if $adminUsersError}
	<div class="p-4 bg-red-50 border border-red-200 rounded-md">
		<p class="text-sm text-red-600">{$adminUsersError}</p>
	</div>
{:else}
	<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
		<!-- Organization Info -->
		<div class="bg-white rounded-lg shadow p-6">
			<h2 class="text-lg font-semibold text-gray-900 mb-4">Organization</h2>
			<dl class="space-y-3">
				{#if $authStore.organizationName}
					<div class="flex justify-between">
						<dt class="text-sm text-gray-500">Name</dt>
						<dd class="text-sm font-medium text-gray-900">{$authStore.organizationName}</dd>
					</div>
				{/if}
				<div class="flex justify-between">
					<dt class="text-sm text-gray-500">Total Users</dt>
					<dd class="text-sm font-medium text-gray-900">{users.length}</dd>
				</div>
				<div class="flex justify-between">
					<dt class="text-sm text-gray-500">Active</dt>
					<dd class="text-sm font-medium text-green-700">{activeCount}</dd>
				</div>
				{#if deactivatedCount > 0}
					<div class="flex justify-between">
						<dt class="text-sm text-gray-500">Deactivated</dt>
						<dd class="text-sm font-medium text-red-600">{deactivatedCount}</dd>
					</div>
				{/if}
			</dl>
		</div>

		<!-- Role Distribution -->
		<div class="bg-white rounded-lg shadow p-6">
			<h2 class="text-lg font-semibold text-gray-900 mb-4">Roles</h2>
			<dl class="space-y-3">
				<div class="flex justify-between items-center">
					<dt class="text-sm text-gray-500">Owners</dt>
					<dd>
						<span
							class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-purple-100 text-purple-800"
						>
							{ownerCount}
						</span>
					</dd>
				</div>
				<div class="flex justify-between items-center">
					<dt class="text-sm text-gray-500">Admins</dt>
					<dd>
						<span
							class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800"
						>
							{adminCount}
						</span>
					</dd>
				</div>
				<div class="flex justify-between items-center">
					<dt class="text-sm text-gray-500">Members</dt>
					<dd>
						<span
							class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800"
						>
							{memberCount}
						</span>
					</dd>
				</div>
				{#if viewerCount > 0}
					<div class="flex justify-between items-center">
						<dt class="text-sm text-gray-500">Viewers</dt>
						<dd>
							<span
								class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-600"
							>
								{viewerCount}
							</span>
						</dd>
					</div>
				{/if}
			</dl>
		</div>
	</div>

	<!-- Quick Links -->
	<div class="mt-8 grid grid-cols-1 md:grid-cols-2 gap-4">
		<a
			href="/admin/users"
			class="bg-white rounded-lg shadow p-5 hover:shadow-md transition-all duration-200 block"
		>
			<div class="flex items-start gap-3">
				<svg
					class="w-6 h-6 text-blue-500 mt-0.5 shrink-0"
					fill="none"
					stroke="currentColor"
					viewBox="0 0 24 24"
				>
					<path
						stroke-linecap="round"
						stroke-linejoin="round"
						stroke-width="2"
						d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"
					/>
				</svg>
				<div>
					<h3 class="font-medium text-gray-900">Manage Users</h3>
					<p class="text-sm text-gray-500 mt-1">View, edit roles, and manage user accounts</p>
				</div>
			</div>
		</a>

		<a
			href="/admin/organization"
			class="bg-white rounded-lg shadow p-5 hover:shadow-md transition-all duration-200 block"
		>
			<div class="flex items-start gap-3">
				<svg
					class="w-6 h-6 text-blue-500 mt-0.5 shrink-0"
					fill="none"
					stroke="currentColor"
					viewBox="0 0 24 24"
				>
					<path
						stroke-linecap="round"
						stroke-linejoin="round"
						stroke-width="2"
						d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"
					/>
				</svg>
				<div>
					<h3 class="font-medium text-gray-900">Organization Settings</h3>
					<p class="text-sm text-gray-500 mt-1">View and edit organization details</p>
				</div>
			</div>
		</a>
	</div>
{/if}
