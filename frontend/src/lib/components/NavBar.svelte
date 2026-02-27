<script lang="ts">
	import { authStore, logout } from '$lib/stores/auth';

	let plansOpen = false;
</script>

<nav class="bg-white border-b border-gray-200">
	<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
		<div class="flex justify-between h-14 items-center">
			<div class="flex items-center space-x-3">
				<a href="/" class="text-lg font-bold text-gray-900">SertantAI</a>
			</div>

			{#if $authStore.isAuthenticated}
				<div class="flex items-center space-x-4">
					<a href="/dashboard" class="text-sm text-gray-600 hover:text-gray-900">Dashboard</a>
					<a href="/settings/security" class="text-sm text-gray-600 hover:text-gray-900">Settings</a
					>
					<div class="relative">
						<button
							on:click={() => (plansOpen = !plansOpen)}
							on:blur={() => setTimeout(() => (plansOpen = false), 150)}
							class="text-sm text-gray-600 hover:text-gray-900 flex items-center gap-1"
						>
							Plans
							<svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
								<path
									stroke-linecap="round"
									stroke-linejoin="round"
									stroke-width="2"
									d="M19 9l-7 7-7-7"
								/>
							</svg>
						</button>
						{#if plansOpen}
							<div
								class="absolute top-full left-0 mt-1 w-48 bg-white rounded-md shadow-lg border border-gray-200 py-1 z-50"
							>
								<a
									href="/flower-meadow"
									class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Flower Meadow</a
								>
								<a
									href="/atlantic-rainforest"
									class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
									>Atlantic Rainforest</a
								>
							</div>
						{/if}
					</div>
					<div class="text-sm text-gray-500">
						{$authStore.user?.email}
					</div>
					{#if $authStore.role}
						<span
							class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-100 text-blue-800"
						>
							{$authStore.role}
						</span>
					{/if}
					<button
						on:click={() => logout()}
						class="text-sm text-gray-500 hover:text-gray-700 transition-colors duration-200"
					>
						Sign Out
					</button>
				</div>
			{:else}
				<div class="flex items-center space-x-3">
					<a href="/login" class="text-sm text-gray-600 hover:text-gray-900">Sign In</a>
					<a
						href="/register"
						class="text-sm px-3 py-1.5 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors duration-200"
					>
						Register
					</a>
				</div>
			{/if}
		</div>
	</div>
</nav>
