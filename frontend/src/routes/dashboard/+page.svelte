<script lang="ts">
	import { authStore } from '$lib/stores/auth';
</script>

<main class="min-h-screen bg-gray-50">
	<div class="max-w-5xl mx-auto px-4 py-12">
		<h1 class="text-3xl font-bold text-gray-900 mb-8">Dashboard</h1>

		<!-- Account Card -->
		<div class="max-w-md bg-white rounded-lg shadow-lg p-6 mb-8">
			<h2 class="text-lg font-semibold text-gray-900 mb-4">Your Account</h2>
			<div class="space-y-3">
				<div class="flex justify-between">
					<span class="text-sm text-gray-500">Email</span>
					<span class="text-sm font-medium text-gray-900">{$authStore.user?.email}</span>
				</div>
				{#if $authStore.role}
					<div class="flex justify-between">
						<span class="text-sm text-gray-500">Role</span>
						<span
							class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-100 text-blue-800"
						>
							{$authStore.role}
						</span>
					</div>
				{/if}
				{#if $authStore.organizationId}
					<div class="flex justify-between">
						<span class="text-sm text-gray-500">Organization</span>
						<span class="text-sm font-mono text-gray-600"
							>{$authStore.organizationId.slice(0, 8)}...</span
						>
					</div>
				{/if}
			</div>
		</div>

		<!-- Services Quick Links -->
		<h2 class="text-lg font-semibold text-gray-900 mb-4">Services</h2>
		<div class="grid grid-cols-1 md:grid-cols-3 gap-4">
			<div class="bg-white rounded-lg shadow p-4 border-l-4 border-blue-500">
				<h3 class="font-medium text-gray-900">Legal</h3>
				<p class="text-sm text-gray-500 mt-1">UK legal registers</p>
				<span
					class="inline-flex items-center mt-2 px-2 py-0.5 rounded-full text-xs font-medium bg-amber-100 text-amber-800"
				>
					In Development
				</span>
			</div>
			<div class="bg-white rounded-lg shadow p-4 border-l-4 border-blue-500">
				<h3 class="font-medium text-gray-900">Enforcement</h3>
				<p class="text-sm text-gray-500 mt-1">Regulatory enforcement data</p>
				<span
					class="inline-flex items-center mt-2 px-2 py-0.5 rounded-full text-xs font-medium bg-amber-100 text-amber-800"
				>
					In Development
				</span>
			</div>
			<div class="bg-white rounded-lg shadow p-4 border-l-4 border-blue-500">
				<h3 class="font-medium text-gray-900">Controls</h3>
				<p class="text-sm text-gray-500 mt-1">Compliance management tools</p>
				<span
					class="inline-flex items-center mt-2 px-2 py-0.5 rounded-full text-xs font-medium bg-amber-100 text-amber-800"
				>
					In Development
				</span>
			</div>
		</div>
	</div>
</main>
