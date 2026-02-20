<script lang="ts">
	import { authStore, logout } from '$lib/stores/auth';
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
