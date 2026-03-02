<script lang="ts">
	import { onMount } from 'svelte';
	import { authStore } from '$lib/stores/auth';
	import { getOrganization } from '$lib/api/organization';
	import type { Organization } from '$lib/api/organization';

	let loading = true;
	let org: Organization | null = null;
	let error = '';

	$: isAdmin = $authStore.role === 'owner' || $authStore.role === 'admin';

	onMount(async () => {
		const result = await getOrganization();
		if (result.ok && result.data) {
			org = result.data;
		} else {
			error = result.error || 'Failed to load organization';
		}
		loading = false;
	});

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

		<h1 class="text-3xl font-bold text-gray-900 mb-2">Organization</h1>
		<p class="text-gray-600 mb-8">View your organization details.</p>

		{#if error}
			<div class="mb-4 p-3 bg-red-50 border border-red-200 rounded-md">
				<p class="text-sm text-red-600">{error}</p>
			</div>
		{/if}

		{#if loading}
			<div class="bg-white rounded-lg shadow-lg p-8 text-center">
				<div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
				<p class="text-gray-500 mt-4">Loading organization...</p>
			</div>
		{:else}
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

				{#if isAdmin}
					<div class="pt-2 border-t border-gray-200">
						<a href="/admin/organization" class="text-sm text-blue-600 hover:text-blue-500">
							Edit in Admin Dashboard &rarr;
						</a>
					</div>
				{/if}
			</div>
		{/if}
	</div>
</main>
