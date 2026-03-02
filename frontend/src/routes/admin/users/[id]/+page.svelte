<script lang="ts">
	import { onMount } from 'svelte';
	import { page } from '$app/stores';
	import { goto } from '$app/navigation';
	import { authStore } from '$lib/stores/auth';
	import { getUser, changeRole, revokeTokens, killUser, unkillUser } from '$lib/api/admin';
	import type { AdminUserDetail } from '$lib/api/admin';

	type View = 'loading' | 'display' | 'confirm-role' | 'confirm-revoke' | 'confirm-kill';

	let view: View = 'loading';
	let user: AdminUserDetail | null = null;
	let error = '';
	let success = '';
	let loading = false;

	// Role change state
	let selectedRole = '';
	const roles = ['owner', 'admin', 'member', 'viewer'];

	$: userId = $page.params.id as string;
	$: isSelf = userId === $authStore.user?.id;
	$: isOwner = $authStore.role === 'owner';

	onMount(async () => {
		if (!userId) {
			goto('/admin/users');
			return;
		}
		await loadUser();
	});

	async function loadUser() {
		view = 'loading';
		error = '';
		const result = await getUser(userId);
		if (result.ok && result.data) {
			user = result.data;
			selectedRole = user.role;
			view = 'display';
		} else {
			error = result.error || 'Failed to load user';
			view = 'display';
		}
	}

	function startRoleChange() {
		if (!user) return;
		selectedRole = user.role;
		error = '';
		success = '';
		view = 'confirm-role';
	}

	async function confirmRoleChange() {
		if (!user || selectedRole === user.role) {
			view = 'display';
			return;
		}
		loading = true;
		error = '';
		const result = await changeRole(userId, selectedRole);
		loading = false;
		if (result.ok && result.data) {
			user = { ...user, ...result.data, active_token_count: user.active_token_count };
			success = `Role changed to ${selectedRole}`;
			view = 'display';
		} else {
			error = result.error || 'Failed to change role';
			view = 'display';
		}
	}

	function startRevoke() {
		error = '';
		success = '';
		view = 'confirm-revoke';
	}

	async function confirmRevoke() {
		loading = true;
		error = '';
		const result = await revokeTokens(userId);
		loading = false;
		if (result.ok) {
			success = 'All tokens revoked. User will need to log in again.';
			await loadUser();
		} else {
			error = result.error || 'Failed to revoke tokens';
			view = 'display';
		}
	}

	function startKill() {
		error = '';
		success = '';
		view = 'confirm-kill';
	}

	async function confirmKill() {
		if (!user) return;
		loading = true;
		error = '';
		const result = user.killed_at ? await unkillUser(userId) : await killUser(userId);
		loading = false;
		if (result.ok) {
			success = user.killed_at ? 'User reactivated' : 'User deactivated and all tokens revoked';
			await loadUser();
		} else {
			error = result.error || 'Operation failed';
			view = 'display';
		}
	}

	function cancel() {
		view = 'display';
	}

	function roleBadgeClass(role: string): string {
		switch (role) {
			case 'owner':
				return 'bg-purple-100 text-purple-800';
			case 'admin':
				return 'bg-blue-100 text-blue-800';
			default:
				return 'bg-gray-100 text-gray-800';
		}
	}

	function formatDate(dateStr: string): string {
		return new Date(dateStr).toLocaleDateString('en-GB', {
			day: 'numeric',
			month: 'short',
			year: 'numeric',
			hour: '2-digit',
			minute: '2-digit'
		});
	}
</script>

<div class="mb-4">
	<a href="/admin/users" class="text-sm text-blue-600 hover:text-blue-500">&larr; All Users</a>
</div>

{#if error}
	<div class="mb-4 p-3 bg-red-50 border border-red-200 rounded-md">
		<p class="text-sm text-red-600">{error}</p>
	</div>
{/if}

{#if success}
	<div class="mb-4 p-3 bg-green-50 border border-green-200 rounded-md">
		<p class="text-sm text-green-700">{success}</p>
	</div>
{/if}

{#if view === 'loading'}
	<div class="text-center py-12">
		<div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
		<p class="text-gray-500 mt-4">Loading user...</p>
	</div>
{:else if user}
	<!-- User Info Card -->
	<div class="bg-white rounded-lg shadow-lg p-8 mb-6">
		<div class="flex items-start justify-between mb-6">
			<div>
				<h2 class="text-xl font-semibold text-gray-900">{user.name || user.email}</h2>
				<p class="text-sm text-gray-500">{user.email}</p>
			</div>
			<div class="flex items-center gap-2">
				<span
					class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium {roleBadgeClass(
						user.role
					)}"
				>
					{user.role}
				</span>
				{#if user.killed_at}
					<span
						class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800"
					>
						Deactivated
					</span>
				{/if}
			</div>
		</div>

		<dl class="grid grid-cols-1 sm:grid-cols-2 gap-4">
			<div>
				<dt class="text-xs text-gray-500 uppercase tracking-wide">Joined</dt>
				<dd class="text-sm text-gray-900 mt-1">{formatDate(user.inserted_at)}</dd>
			</div>
			<div>
				<dt class="text-xs text-gray-500 uppercase tracking-wide">Active Sessions</dt>
				<dd class="text-sm text-gray-900 mt-1">{user.active_token_count}</dd>
			</div>
			<div>
				<dt class="text-xs text-gray-500 uppercase tracking-wide">User ID</dt>
				<dd class="text-sm font-mono text-gray-500 mt-1">{user.id}</dd>
			</div>
			{#if user.killed_at}
				<div>
					<dt class="text-xs text-gray-500 uppercase tracking-wide">Deactivated At</dt>
					<dd class="text-sm text-red-600 mt-1">{formatDate(user.killed_at)}</dd>
				</div>
			{/if}
		</dl>
	</div>

	<!-- Actions -->
	{#if !isSelf}
		<!-- Role Management (Owner only) -->
		{#if isOwner}
			<div class="bg-white rounded-lg shadow p-6 mb-6">
				<h3 class="text-sm font-semibold text-gray-900 uppercase tracking-wide mb-4">
					Role Management
				</h3>

				{#if view === 'confirm-role'}
					<div class="space-y-4">
						<p class="text-sm text-gray-600">
							Change role for <strong>{user.name || user.email}</strong>:
						</p>
						<select
							bind:value={selectedRole}
							class="rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
						>
							{#each roles as role}
								<option value={role}>{role}</option>
							{/each}
						</select>
						<div class="flex gap-3">
							<button
								on:click={confirmRoleChange}
								disabled={loading || selectedRole === user.role}
								class="px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-lg hover:bg-blue-700 disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors"
							>
								{loading ? 'Saving...' : 'Confirm Change'}
							</button>
							<button
								on:click={cancel}
								class="px-4 py-2 text-gray-600 text-sm font-medium rounded-lg hover:bg-gray-100 transition-colors"
							>
								Cancel
							</button>
						</div>
					</div>
				{:else}
					<div class="flex items-center justify-between">
						<p class="text-sm text-gray-600">
							Current role: <span class="font-medium">{user.role}</span>
						</p>
						<button
							on:click={startRoleChange}
							class="px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-lg hover:bg-blue-700 transition-colors"
						>
							Change Role
						</button>
					</div>
				{/if}
			</div>
		{/if}

		<!-- Session Management -->
		<div class="bg-white rounded-lg shadow p-6 mb-6">
			<h3 class="text-sm font-semibold text-gray-900 uppercase tracking-wide mb-4">
				Session Management
			</h3>

			{#if view === 'confirm-revoke'}
				<div class="space-y-4">
					<p class="text-sm text-gray-600">
						Revoke all tokens for <strong>{user.name || user.email}</strong>? They will be logged
						out of all devices and need to sign in again.
					</p>
					<div class="flex gap-3">
						<button
							on:click={confirmRevoke}
							disabled={loading}
							class="px-4 py-2 bg-amber-600 text-white text-sm font-medium rounded-lg hover:bg-amber-700 disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors"
						>
							{loading ? 'Revoking...' : 'Confirm Revoke'}
						</button>
						<button
							on:click={cancel}
							class="px-4 py-2 text-gray-600 text-sm font-medium rounded-lg hover:bg-gray-100 transition-colors"
						>
							Cancel
						</button>
					</div>
				</div>
			{:else}
				<div class="flex items-center justify-between">
					<p class="text-sm text-gray-600">
						{user.active_token_count} active session{user.active_token_count !== 1 ? 's' : ''}
					</p>
					<button
						on:click={startRevoke}
						class="px-4 py-2 bg-amber-600 text-white text-sm font-medium rounded-lg hover:bg-amber-700 transition-colors"
					>
						Revoke All Tokens
					</button>
				</div>
			{/if}
		</div>

		<!-- Danger Zone (Owner only) -->
		{#if isOwner}
			<div class="bg-white rounded-lg shadow border border-red-200 p-6">
				<h3 class="text-sm font-semibold text-red-700 uppercase tracking-wide mb-4">Danger Zone</h3>

				{#if view === 'confirm-kill'}
					<div class="space-y-4">
						{#if user.killed_at}
							<p class="text-sm text-gray-600">
								Reactivate <strong>{user.name || user.email}</strong>? They will be able to log in
								again.
							</p>
						{:else}
							<p class="text-sm text-gray-600">
								Deactivate <strong>{user.name || user.email}</strong>? This will revoke all their
								tokens and prevent them from logging in.
							</p>
						{/if}
						<div class="flex gap-3">
							<button
								on:click={confirmKill}
								disabled={loading}
								class="px-4 py-2 {user.killed_at
									? 'bg-green-600 hover:bg-green-700'
									: 'bg-red-600 hover:bg-red-700'} text-white text-sm font-medium rounded-lg disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors"
							>
								{#if loading}
									Processing...
								{:else if user.killed_at}
									Confirm Reactivate
								{:else}
									Confirm Deactivate
								{/if}
							</button>
							<button
								on:click={cancel}
								class="px-4 py-2 text-gray-600 text-sm font-medium rounded-lg hover:bg-gray-100 transition-colors"
							>
								Cancel
							</button>
						</div>
					</div>
				{:else}
					<div class="flex items-center justify-between">
						<p class="text-sm text-gray-600">
							{#if user.killed_at}
								This account is deactivated. Reactivate to allow login.
							{:else}
								Deactivate this account to revoke access and prevent login.
							{/if}
						</p>
						<button
							on:click={startKill}
							class="px-4 py-2 {user.killed_at
								? 'bg-green-600 hover:bg-green-700'
								: 'bg-red-600 hover:bg-red-700'} text-white text-sm font-medium rounded-lg transition-colors"
						>
							{user.killed_at ? 'Reactivate Account' : 'Deactivate Account'}
						</button>
					</div>
				{/if}
			</div>
		{/if}
	{:else}
		<div class="bg-blue-50 border border-blue-200 rounded-md p-4">
			<p class="text-sm text-blue-700">
				This is your own account. Use the settings pages to manage your profile.
			</p>
		</div>
	{/if}
{:else}
	<div class="text-center py-12">
		<p class="text-gray-500">User not found</p>
		<a href="/admin/users" class="text-sm text-blue-600 hover:text-blue-500 mt-2 inline-block"
			>Back to Users</a
		>
	</div>
{/if}
