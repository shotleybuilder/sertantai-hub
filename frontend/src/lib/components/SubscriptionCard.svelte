<script lang="ts">
	import type { Subscription } from '$lib/types/notifications';
	import { createEventDispatcher } from 'svelte';

	export let subscription: Subscription;

	const dispatch = createEventDispatcher<{
		edit: Subscription;
		delete: Subscription;
		toggle: Subscription;
	}>();

	function formatFrequency(freq: string): string {
		switch (freq) {
			case 'immediate':
				return 'Immediate';
			case 'daily_digest':
				return 'Daily Digest';
			case 'weekly_digest':
				return 'Weekly Digest';
			default:
				return freq;
		}
	}

	function formatFilters(sub: Subscription): string[] {
		const filters: string[] = [];
		if (sub.law_families.length) filters.push(`Families: ${sub.law_families.join(', ')}`);
		if (sub.geo_extent.length) filters.push(`Extent: ${sub.geo_extent.join(', ')}`);
		if (sub.change_types.length) filters.push(`Types: ${sub.change_types.join(', ')}`);
		if (sub.keywords.length) filters.push(`Keywords: ${sub.keywords.join(', ')}`);
		if (sub.type_codes.length) filters.push(`Codes: ${sub.type_codes.join(', ')}`);
		if (!filters.length) filters.push('All law changes (no filters)');
		return filters;
	}
</script>

<div
	class="bg-white rounded-lg shadow p-5 border-l-4 {subscription.enabled
		? 'border-blue-500'
		: 'border-gray-300 opacity-75'}"
>
	<div class="flex items-start justify-between">
		<div class="flex-1 min-w-0">
			<div class="flex items-center gap-2">
				<h3 class="font-medium text-gray-900 truncate">{subscription.name}</h3>
				{#if !subscription.enabled}
					<span
						class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-gray-100 text-gray-600"
					>
						Paused
					</span>
				{/if}
			</div>

			<div class="mt-2 flex items-center gap-3">
				<span
					class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-50 text-blue-700"
				>
					{formatFrequency(subscription.frequency)}
				</span>
				<span class="text-xs text-gray-400">
					{subscription.delivery_methods.join(', ')}
				</span>
			</div>

			<div class="mt-2 space-y-1">
				{#each formatFilters(subscription) as filter}
					<p class="text-xs text-gray-500">{filter}</p>
				{/each}
			</div>
		</div>

		<div class="flex items-center gap-1 ml-4 shrink-0">
			<button
				on:click={() => dispatch('toggle', subscription)}
				class="p-1.5 rounded-md text-gray-400 hover:text-gray-600 hover:bg-gray-100 transition-colors"
				title={subscription.enabled ? 'Pause' : 'Enable'}
			>
				{#if subscription.enabled}
					<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
						<path
							stroke-linecap="round"
							stroke-linejoin="round"
							stroke-width="2"
							d="M10 9v6m4-6v6m7-3a9 9 0 11-18 0 9 9 0 0118 0z"
						/>
					</svg>
				{:else}
					<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
						<path
							stroke-linecap="round"
							stroke-linejoin="round"
							stroke-width="2"
							d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z"
						/>
						<path
							stroke-linecap="round"
							stroke-linejoin="round"
							stroke-width="2"
							d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
						/>
					</svg>
				{/if}
			</button>
			<button
				on:click={() => dispatch('edit', subscription)}
				class="p-1.5 rounded-md text-gray-400 hover:text-blue-600 hover:bg-blue-50 transition-colors"
				title="Edit"
			>
				<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
					<path
						stroke-linecap="round"
						stroke-linejoin="round"
						stroke-width="2"
						d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
					/>
				</svg>
			</button>
			<button
				on:click={() => dispatch('delete', subscription)}
				class="p-1.5 rounded-md text-gray-400 hover:text-red-600 hover:bg-red-50 transition-colors"
				title="Delete"
			>
				<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
					<path
						stroke-linecap="round"
						stroke-linejoin="round"
						stroke-width="2"
						d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
					/>
				</svg>
			</button>
		</div>
	</div>
</div>
