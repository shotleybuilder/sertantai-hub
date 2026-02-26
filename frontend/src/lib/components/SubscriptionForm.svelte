<script lang="ts">
	import { createEventDispatcher } from 'svelte';
	import type { Subscription, CreateSubscriptionParams } from '$lib/types/notifications';

	export let subscription: Subscription | null = null;
	export let loading = false;

	const dispatch = createEventDispatcher<{
		submit: CreateSubscriptionParams;
		cancel: void;
	}>();

	let name = subscription?.name ?? '';
	let lawFamilies = subscription?.law_families.join(', ') ?? '';
	let geoExtent = subscription?.geo_extent.join(', ') ?? '';
	let changeTypes = subscription?.change_types.join(', ') ?? '';
	let keywords = subscription?.keywords.join(', ') ?? '';
	let typeCodes = subscription?.type_codes.join(', ') ?? '';
	let frequency = subscription?.frequency ?? 'daily_digest';

	function parseList(value: string): string[] {
		return value
			.split(',')
			.map((s) => s.trim())
			.filter((s) => s.length > 0);
	}

	function handleSubmit() {
		if (!name.trim()) return;
		dispatch('submit', {
			name: name.trim(),
			law_families: parseList(lawFamilies),
			geo_extent: parseList(geoExtent),
			change_types: parseList(changeTypes),
			keywords: parseList(keywords),
			type_codes: parseList(typeCodes),
			frequency
		});
	}
</script>

<form on:submit|preventDefault={handleSubmit} class="space-y-4">
	<div>
		<label for="sub-name" class="block text-sm font-medium text-gray-700">Name</label>
		<input
			id="sub-name"
			type="text"
			bind:value={name}
			required
			placeholder="e.g. Scottish Climate Laws"
			class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
		/>
	</div>

	<div>
		<label for="sub-families" class="block text-sm font-medium text-gray-700">Law Families</label>
		<input
			id="sub-families"
			type="text"
			bind:value={lawFamilies}
			placeholder="e.g. E:CLIMATE, HS:HEALTH"
			class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
		/>
		<p class="mt-1 text-xs text-gray-400">Comma-separated. Leave empty to match all.</p>
	</div>

	<div>
		<label for="sub-extent" class="block text-sm font-medium text-gray-700">Geographic Extent</label
		>
		<input
			id="sub-extent"
			type="text"
			bind:value={geoExtent}
			placeholder="e.g. S, E+W, E+W+S+NI"
			class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
		/>
		<p class="mt-1 text-xs text-gray-400">Comma-separated. Leave empty to match all.</p>
	</div>

	<div>
		<label for="sub-types" class="block text-sm font-medium text-gray-700">Change Types</label>
		<input
			id="sub-types"
			type="text"
			bind:value={changeTypes}
			placeholder="e.g. new, amended, repealed, commenced"
			class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
		/>
		<p class="mt-1 text-xs text-gray-400">Comma-separated. Leave empty to match all.</p>
	</div>

	<div>
		<label for="sub-keywords" class="block text-sm font-medium text-gray-700">Keywords</label>
		<input
			id="sub-keywords"
			type="text"
			bind:value={keywords}
			placeholder="e.g. climate change, emissions"
			class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
		/>
		<p class="mt-1 text-xs text-gray-400">Comma-separated. Matches title and name.</p>
	</div>

	<div>
		<label for="sub-codes" class="block text-sm font-medium text-gray-700"
			>Legislation Type Codes</label
		>
		<input
			id="sub-codes"
			type="text"
			bind:value={typeCodes}
			placeholder="e.g. ukpga, asp, uksi"
			class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
		/>
		<p class="mt-1 text-xs text-gray-400">Comma-separated. Leave empty to match all.</p>
	</div>

	<div>
		<label for="sub-freq" class="block text-sm font-medium text-gray-700">Frequency</label>
		<select
			id="sub-freq"
			bind:value={frequency}
			class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
		>
			<option value="daily_digest">Daily Digest</option>
			<option value="immediate">Immediate</option>
			<option value="weekly_digest">Weekly Digest</option>
		</select>
		<p class="mt-1 text-xs text-gray-400">Free tier: daily digest only.</p>
	</div>

	<div class="flex gap-3 pt-2">
		<button
			type="submit"
			disabled={loading || !name.trim()}
			class="px-4 py-2 bg-blue-600 text-white font-medium rounded-lg
				hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
				disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors duration-200"
		>
			{loading ? 'Saving...' : subscription ? 'Update' : 'Create'}
		</button>
		<button
			type="button"
			on:click={() => dispatch('cancel')}
			class="px-4 py-2 text-gray-600 font-medium rounded-lg border border-gray-300
				hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2
				transition-colors duration-200"
		>
			Cancel
		</button>
	</div>
</form>
