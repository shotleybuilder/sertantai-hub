<script lang="ts">
	import { authStore } from '$lib/stores/auth';
	import ServiceTile from '$lib/components/ServiceTile.svelte';

	// Mock subscription data — replace with real data when backend supports it
	const subscriptions = {
		legal: 'blanket_bog' as const,
		enforcement: 'blanket_bog' as const,
		controls: 'blanket_bog' as const
	};
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

		<!-- Services -->
		<h2 class="text-lg font-semibold text-gray-900 mb-4">Services</h2>
		<div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-12">
			<ServiceTile
				name="Legal"
				description="UK legal registers"
				url="http://localhost:5175/browse"
				healthUrl="http://localhost:4003/health"
				tier={subscriptions.legal}
			/>
			<ServiceTile
				name="Enforcement"
				description="Regulatory enforcement data"
				url="http://localhost:5174"
				healthUrl="http://localhost:4001/health"
				tier={subscriptions.enforcement}
			/>
			<ServiceTile
				name="Controls"
				description="Compliance management tools"
				url="http://localhost:5176"
				healthUrl="http://localhost:4004/health"
				tier={subscriptions.controls}
			/>
		</div>

		<!-- Account Admin -->
		<h2 class="text-lg font-semibold text-gray-900 mb-4">Account Management</h2>
		<div class="grid grid-cols-1 md:grid-cols-2 gap-4">
			<!-- Profile -->
			<div class="relative bg-white rounded-lg shadow p-5 opacity-75">
				<span
					class="absolute top-3 right-3 inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-600"
				>
					Coming Soon
				</span>
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
							d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
						/>
					</svg>
					<div>
						<h3 class="font-medium text-gray-900">Profile</h3>
						<p class="text-sm text-gray-500 mt-1">Edit your name, email, and password</p>
						<p class="text-xs text-gray-400 mt-2">{$authStore.user?.email}</p>
					</div>
				</div>
			</div>

			<!-- Organization -->
			<div class="relative bg-white rounded-lg shadow p-5 opacity-75">
				<span
					class="absolute top-3 right-3 inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-600"
				>
					Coming Soon
				</span>
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
						<h3 class="font-medium text-gray-900">Organization</h3>
						<p class="text-sm text-gray-500 mt-1">Manage organization settings</p>
						{#if $authStore.organizationId}
							<p class="text-xs text-gray-400 mt-2 font-mono">
								{$authStore.organizationId.slice(0, 8)}...
							</p>
						{/if}
					</div>
				</div>
			</div>

			<!-- Subscription & Billing -->
			<div class="relative bg-white rounded-lg shadow p-5 opacity-75">
				<span
					class="absolute top-3 right-3 inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-600"
				>
					Coming Soon
				</span>
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
							d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"
						/>
					</svg>
					<div>
						<h3 class="font-medium text-gray-900">Subscription & Billing</h3>
						<p class="text-sm text-gray-500 mt-1">Manage your service tiers and payment methods</p>
						<p class="text-xs text-gray-400 mt-2">All services: Blanket Bog (Free)</p>
					</div>
				</div>
			</div>

			<!-- Team Members (owner/admin only) -->
			{#if $authStore.role === 'owner' || $authStore.role === 'admin'}
				<div class="relative bg-white rounded-lg shadow p-5 opacity-75">
					<span
						class="absolute top-3 right-3 inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-600"
					>
						Coming Soon
					</span>
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
							<h3 class="font-medium text-gray-900">Team Members</h3>
							<p class="text-sm text-gray-500 mt-1">Invite and manage users in your organization</p>
							<span
								class="inline-flex items-center mt-2 px-2 py-0.5 rounded text-xs font-medium bg-blue-100 text-blue-800"
							>
								{$authStore.role}
							</span>
						</div>
					</div>
				</div>
			{/if}
		</div>
	</div>
</main>
