<script lang="ts">
	import { onMount } from 'svelte';
	import { authStore } from '$lib/stores/auth';
	import { getOrganization, updateOrganization } from '$lib/api/organization';
	import type { Organization } from '$lib/api/organization';

	type View = 'loading' | 'organization' | 'edit';

	let view: View = 'loading';
	let org: Organization | null = null;
	let loading = false;
	let error = '';
	let success = '';

	// Edit state
	let editName = '';

	onMount(async () => {
		const result = await getOrganization();
		if (result.ok && result.data) {
			org = result.data;
		} else {
			error = result.error || 'Failed to load organization';
		}
		view = 'organization';
	});

	function startEdit() {
		if (!org) return;
		editName = org.name;
		error = '';
		success = '';
		view = 'edit';
	}

	async function handleSave() {
		if (!org) return;
		loading = true;
		error = '';

		if (editName === org.name) {
			view = 'organization';
			loading = false;
			return;
		}

		const result = await updateOrganization({ name: editName });
		loading = false;

		if (result.ok && result.data) {
			org = result.data;
			// Update auth store with new org name
			authStore.update((state) => ({
				...state,
				organizationName: result.data!.name
			}));
			success = 'Organization updated successfully.';
			view = 'organization';
		} else {
			error = result.error || 'Failed to update organization';
		}
	}

	function cancel() {
		error = '';
		view = 'organization';
	}

	function tierBadgeClass(tier: string): string {
		switch (tier) {
			case 'premium':
				return 'bg-purple-100 text-purple-800';
			case 'standard':
				return 'bg-blue-100 text-blue-800';
			default:
				return 'bg-gray-100 text-gray-800';
		}
	}
</script>

<main class="min-h-screen bg-gray-50">
	<div class="max-w-lg mx-auto px-4 py-12">
		<div class="mb-6">
			<a href="/dashboard" class="text-sm text-blue-600 hover:text-blue-500">&larr; Dashboard</a>
		</div>

		<h1 class="text-3xl font-bold text-gray-900 mb-2">Organization Settings</h1>
		<p class="text-gray-600 mb-8">Manage your organization name and view account details.</p>

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

		<!-- Loading -->
		{#if view === 'loading'}
			<div class="bg-white rounded-lg shadow-lg p-8 text-center">
				<div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
				<p class="text-gray-500 mt-4">Loading organization...</p>
			</div>

			<!-- Organization View -->
		{:else if view === 'organization'}
			<div class="bg-white rounded-lg shadow-lg p-8 space-y-6">
				<div>
					<h2 class="text-lg font-semibold text-gray-900 mb-4">Organization Information</h2>
					<dl class="space-y-3">
						<div class="flex justify-between">
							<dt class="text-sm text-gray-500">Name</dt>
							<dd class="text-sm font-medium text-gray-900">
								{org?.name || '—'}
							</dd>
						</div>
						<div class="flex justify-between">
							<dt class="text-sm text-gray-500">Slug</dt>
							<dd class="text-sm font-mono text-gray-600">
								{org?.slug || '—'}
							</dd>
						</div>
						<div class="flex justify-between">
							<dt class="text-sm text-gray-500">Tier</dt>
							<dd>
								<span
									class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium {tierBadgeClass(
										org?.tier || 'free'
									)}"
								>
									{org?.tier || 'free'}
								</span>
							</dd>
						</div>
						{#if $authStore.organizationId}
							<div class="flex justify-between">
								<dt class="text-sm text-gray-500">ID</dt>
								<dd class="text-sm font-mono text-gray-400">
									{$authStore.organizationId}
								</dd>
							</div>
						{/if}
					</dl>
				</div>

				<div class="flex gap-3 pt-2 border-t border-gray-200">
					<button
						on:click={startEdit}
						class="px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-lg
							hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
							transition-colors duration-200"
					>
						Edit Organization
					</button>
				</div>
			</div>

			<!-- Edit Organization Form -->
		{:else if view === 'edit'}
			<div class="bg-white rounded-lg shadow-lg p-8 space-y-6">
				<h2 class="text-lg font-semibold text-gray-900">Edit Organization</h2>

				<div>
					<label for="name" class="block text-sm font-medium text-gray-700 mb-1">Name</label>
					<input
						id="name"
						type="text"
						bind:value={editName}
						placeholder="Organization name"
						class="w-full rounded-md border-gray-300 shadow-sm
							focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
					/>
				</div>

				<div class="flex gap-3">
					<button
						on:click={handleSave}
						disabled={loading}
						class="px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-lg
							hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
							disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors duration-200"
					>
						{loading ? 'Saving...' : 'Save Changes'}
					</button>
					<button
						on:click={cancel}
						class="px-4 py-2 text-gray-600 text-sm font-medium rounded-lg
							hover:bg-gray-100 transition-colors duration-200"
					>
						Cancel
					</button>
				</div>
			</div>
		{/if}
	</div>
</main>
