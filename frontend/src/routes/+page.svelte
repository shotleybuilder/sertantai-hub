<script lang="ts">
	import { authStore } from '$lib/stores/auth';
	import { goto } from '$app/navigation';
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
			<div class="mt-8 flex flex-col sm:flex-row gap-4 justify-center">
				{#if $authStore.isAuthenticated}
					<button
						on:click={() => goto('/dashboard')}
						class="px-6 py-3 bg-white text-blue-700 font-semibold rounded-lg hover:bg-blue-50 transition-colors duration-200"
					>
						Go to Dashboard
					</button>
				{:else}
					<a
						href="/register"
						class="px-6 py-3 bg-white text-blue-700 font-semibold rounded-lg hover:bg-blue-50 transition-colors duration-200"
					>
						Create Free Account
					</a>
					<a
						href="/login"
						class="px-6 py-3 border-2 border-white text-white font-semibold rounded-lg hover:bg-white/10 transition-colors duration-200"
					>
						Sign In
					</a>
				{/if}
			</div>
		</div>
	</section>

	<!-- Plans -->
	{#if !$authStore.isAuthenticated}
		<section class="max-w-5xl mx-auto px-4 py-16">
			<h2 class="text-2xl font-bold text-gray-900 text-center mb-3">Plans</h2>
			<p class="text-center text-gray-500 mb-10 max-w-2xl mx-auto">
				Free core access for everyone. Premium tiers for teams that need more.
			</p>
			<div class="grid grid-cols-1 md:grid-cols-3 gap-6">
				<a
					href="/blanket-bog"
					class="bg-gray-50 rounded-lg p-6 hover:shadow-lg transition-shadow duration-200 block border border-gray-200"
				>
					<span
						class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-emerald-100 text-emerald-800 mb-3"
					>
						Free
					</span>
					<h3 class="text-lg font-semibold text-gray-900 mb-2">Blanket Bog</h3>
					<p class="text-sm text-gray-600">
						Browse curated legal registers and enforcement data with interactive tables, local-first
						speed, and AI-supported queries.
					</p>
				</a>
				<a
					href="/flower-meadow"
					class="bg-gray-50 rounded-lg p-6 hover:shadow-lg transition-shadow duration-200 block border border-gray-200"
				>
					<span
						style="background-color: #f3e8ff; color: #6b21a8;"
						class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium mb-3"
					>
						Professional
					</span>
					<h3 class="text-lg font-semibold text-gray-900 mb-2">Flower Meadow</h3>
					<p class="text-sm text-gray-600">
						Peer-to-peer compliance platform with AI micro-apps, data sovereignty, and offline
						capability. Your data, your device, zero cloud.
					</p>
				</a>
				<a
					href="/atlantic-rainforest"
					class="bg-gray-50 rounded-lg p-6 hover:shadow-lg transition-shadow duration-200 block border border-gray-200"
				>
					<span
						style="background-color: #d1fae5; color: #065f46;"
						class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium mb-3"
					>
						Enterprise
					</span>
					<h3 class="text-lg font-semibold text-gray-900 mb-2">Atlantic Rainforest</h3>
					<p class="text-sm text-gray-600">
						Sync compliance data into your own open-source platform. Baserow, NocoDB, Grist &mdash;
						build solutions your way.
					</p>
				</a>
			</div>
		</section>
	{/if}

	<!-- Mission -->
	<section class="bg-white border-y border-gray-200">
		<div class="max-w-3xl mx-auto px-4 py-16 text-center">
			<h2 class="text-2xl font-bold text-gray-900 mb-6">Our Mission</h2>
			<p class="text-gray-600 leading-relaxed mb-4">
				SertantAI is a not-for-profit creating information services for environment, health &amp;
				safety, and enforcement professionals. Our data is your data under a liberal creative
				commons licence.
			</p>
			<p class="text-gray-600 leading-relaxed mb-4">
				Core services are free for all registered users. Revenue from premium tiers funds platform
				development and supports micro urban community environmental projects. We work towards 100%
				of surplus income funding community work.
			</p>
			<p class="text-gray-600 leading-relaxed">
				No profit extraction &mdash; every pound goes back into making compliance accessible and
				supporting local environmental action.
			</p>
		</div>
	</section>

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
