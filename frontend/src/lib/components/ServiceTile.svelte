<script lang="ts">
	import { onMount, onDestroy } from 'svelte';

	export let name: string;
	export let description: string;
	export let url: string;
	export let healthUrl: string;
	export let tier: 'blanket_bog' | 'flower_meadow' | 'atlantic_rainforest' = 'blanket_bog';

	type HealthStatus = 'checking' | 'online' | 'offline';
	let status: HealthStatus = 'checking';
	let pollTimer: ReturnType<typeof setInterval> | null = null;

	const tierConfig = {
		blanket_bog: { label: 'Blanket Bog', bg: 'bg-green-100', text: 'text-green-800' },
		flower_meadow: { label: 'Flower Meadow', bg: 'bg-amber-100', text: 'text-amber-800' },
		atlantic_rainforest: {
			label: 'Atlantic Rainforest',
			bg: 'bg-purple-100',
			text: 'text-purple-800'
		}
	};

	const statusConfig = {
		checking: { dot: 'bg-gray-400', label: 'Checking...' },
		online: { dot: 'bg-green-500', label: 'Online' },
		offline: { dot: 'bg-red-500', label: 'Offline' }
	};

	async function checkHealth() {
		try {
			const controller = new AbortController();
			const timeout = setTimeout(() => controller.abort(), 3000);
			const res = await fetch(healthUrl, { signal: controller.signal });
			clearTimeout(timeout);
			if (!res.ok) {
				status = 'offline';
			} else {
				const data = await res.json();
				status = data.status === 'ok' || data.status === 'healthy' ? 'online' : 'offline';
			}
		} catch {
			status = 'offline';
		}
	}

	onMount(() => {
		checkHealth();
		pollTimer = setInterval(checkHealth, 30_000);
	});

	onDestroy(() => {
		if (pollTimer) clearInterval(pollTimer);
	});

	$: currentTier = tierConfig[tier];
	$: currentStatus = statusConfig[status];
</script>

<a
	href={url}
	class="bg-white rounded-lg shadow p-4 border-l-4 border-blue-500 hover:shadow-md hover:bg-blue-50/50 transition-all duration-200 block"
>
	<div class="flex items-center justify-between mb-1">
		<h3 class="font-medium text-gray-900">{name}</h3>
		<span class="inline-flex items-center gap-1.5 text-xs text-gray-500">
			<span class="w-2 h-2 rounded-full {currentStatus.dot}"></span>
			{currentStatus.label}
		</span>
	</div>
	<p class="text-sm text-gray-500 mt-1">{description}</p>
	<span
		class="inline-flex items-center mt-2 px-2 py-0.5 rounded-full text-xs font-medium {currentTier.bg} {currentTier.text}"
	>
		{currentTier.label}
	</span>
</a>
