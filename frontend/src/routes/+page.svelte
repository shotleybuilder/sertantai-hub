<script lang="ts">
	import { authStore } from '$lib/stores/auth';
</script>

<main class="min-h-screen bg-gray-50">
	<!-- Hero -->
	<section class="bg-gradient-to-br from-blue-600 to-blue-800 text-white">
		<div class="max-w-5xl mx-auto px-4 py-16 sm:py-24 text-center">
			<h1 class="text-4xl sm:text-5xl font-bold tracking-tight mb-4">SertantAI</h1>
			<p class="text-xl sm:text-2xl font-light text-blue-100 mb-6">
				Compliance intelligence for a better world
			</p>
			<p class="max-w-2xl mx-auto text-blue-200 leading-relaxed">
				A not-for-profit platform providing regulatory compliance services for environment, health
				&amp; safety, and enforcement professionals. Free core access for all registered users.
			</p>
		</div>
	</section>

	<!-- Services -->
	<section class="max-w-5xl mx-auto px-4 py-16">
		<h2 class="text-2xl font-bold text-gray-900 text-center mb-10">Services</h2>
		<div class="grid grid-cols-1 md:grid-cols-3 gap-6">
			<!-- Legal -->
			<div class="bg-white rounded-lg shadow-lg p-6">
				<div class="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center mb-4">
					<svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
						<path
							stroke-linecap="round"
							stroke-linejoin="round"
							stroke-width="2"
							d="M3 6l3 1m0 0l-3 9a5.002 5.002 0 006.001 0M6 7l3 9M6 7l6-2m6 2l3-1m-3 1l-3 9a5.002 5.002 0 006.001 0M18 7l3 9m-3-9l-6-2m0-2v2m0 16V5m0 16H9m3 0h3"
						/>
					</svg>
				</div>
				<h3 class="text-lg font-semibold text-gray-900 mb-2">Legal</h3>
				<p class="text-sm text-gray-600 mb-4">
					UK legal registers for health &amp; safety and environmental legislation. Track primary
					and secondary law across your compliance landscape.
				</p>
				<span
					class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-amber-100 text-amber-800"
				>
					In Development
				</span>
			</div>

			<!-- Enforcement -->
			<div class="bg-white rounded-lg shadow-lg p-6">
				<div class="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center mb-4">
					<svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
						<path
							stroke-linecap="round"
							stroke-linejoin="round"
							stroke-width="2"
							d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"
						/>
					</svg>
				</div>
				<h3 class="text-lg font-semibold text-gray-900 mb-2">Enforcement</h3>
				<p class="text-sm text-gray-600 mb-4">
					Regulatory enforcement data and tracking. Monitor enforcement actions, notices, and
					prosecutions across regulatory bodies.
				</p>
				<span
					class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-amber-100 text-amber-800"
				>
					In Development
				</span>
			</div>

			<!-- Controls -->
			<div class="bg-white rounded-lg shadow-lg p-6">
				<div class="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center mb-4">
					<svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
						<path
							stroke-linecap="round"
							stroke-linejoin="round"
							stroke-width="2"
							d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"
						/>
					</svg>
				</div>
				<h3 class="text-lg font-semibold text-gray-900 mb-2">Controls</h3>
				<p class="text-sm text-gray-600 mb-4">
					Compliance controls and management tools. Maintain your compliance position with
					structured control frameworks and assessments.
				</p>
				<span
					class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-amber-100 text-amber-800"
				>
					In Development
				</span>
			</div>
		</div>
	</section>

	<!-- Mission -->
	<section class="bg-white border-y border-gray-200">
		<div class="max-w-3xl mx-auto px-4 py-16 text-center">
			<h2 class="text-2xl font-bold text-gray-900 mb-6">Our Mission</h2>
			<p class="text-gray-600 leading-relaxed mb-4">
				SertantAI is a not-for-profit creating information services for environment, health &amp;
				safety, and enforcement professionals. All services require registration to ensure quality
				access and protect against automated abuse.
			</p>
			<p class="text-gray-600 leading-relaxed">
				Core services are free for all registered users. Premium tiers provide extended data,
				advanced tools, and dedicated support to fund our mission of making compliance accessible to
				everyone.
			</p>
		</div>
	</section>

	<!-- Account -->
	{#if $authStore.isAuthenticated}
		<section class="max-w-5xl mx-auto px-4 py-16">
			<h2 class="text-2xl font-bold text-gray-900 text-center mb-10">Your Account</h2>
			<div class="max-w-md mx-auto bg-white rounded-lg shadow-lg p-6">
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
		</section>
	{/if}

	<!-- Footer -->
	<footer class="border-t border-gray-200 bg-gray-50">
		<div class="max-w-5xl mx-auto px-4 py-8 text-center text-sm text-gray-500">
			<p>SertantAI &mdash; Not-for-profit compliance intelligence</p>
			<p class="mt-2 text-xs text-gray-400">
				SvelteKit + TypeScript + TailwindCSS + Phoenix + Ash Framework + ElectricSQL
			</p>
		</div>
	</footer>
</main>
