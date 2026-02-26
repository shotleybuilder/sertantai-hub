<script lang="ts">
	import { authStore } from '$lib/stores/auth';
	import { goto } from '$app/navigation';
</script>

<main class="min-h-screen bg-gray-50">
	<!-- Hero -->
	<section class="bg-gradient-to-br from-emerald-700 to-emerald-900 text-white">
		<div class="max-w-5xl mx-auto px-4 py-16 sm:py-20 text-center">
			<span
				class="inline-block px-3 py-1 mb-4 text-sm font-medium bg-white/15 rounded-full backdrop-blur-sm"
			>
				Free Tier
			</span>
			<h1 class="text-4xl sm:text-5xl font-bold tracking-tight mb-4">Blanket Bog</h1>
			<p class="text-xl sm:text-2xl font-light text-emerald-100 mb-6">
				Core compliance intelligence, free for everyone
			</p>
			<p class="max-w-2xl mx-auto text-emerald-200 leading-relaxed">
				Access curated UK legal registers and enforcement data with a fast, local-first experience.
				Browse, filter, and query regulatory data the way you need it &mdash; no subscription
				required.
			</p>
			<div class="mt-8 flex flex-col sm:flex-row gap-4 justify-center">
				{#if $authStore.isAuthenticated}
					<button
						on:click={() => goto('/dashboard')}
						class="px-6 py-3 bg-white text-emerald-700 font-semibold rounded-lg hover:bg-emerald-50 transition-colors duration-200"
					>
						Go to Dashboard
					</button>
				{:else}
					<a
						href="/register"
						class="px-6 py-3 bg-white text-emerald-700 font-semibold rounded-lg hover:bg-emerald-50 transition-colors duration-200"
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

	<!-- What's Included -->
	<section class="max-w-5xl mx-auto px-4 py-16">
		<h2 class="text-2xl font-bold text-gray-900 text-center mb-3">What's Included</h2>
		<p class="text-center text-gray-500 mb-10 max-w-2xl mx-auto">
			Blanket Bog gives registered users access to curated datasets from two core SertantAI
			services.
		</p>

		<div class="grid grid-cols-1 md:grid-cols-2 gap-8">
			<!-- Legal -->
			<div class="bg-white rounded-lg shadow-lg p-6 border-t-4 border-blue-500">
				<div class="flex items-center gap-3 mb-4">
					<div class="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
						<svg
							class="w-6 h-6 text-blue-600"
							fill="none"
							stroke="currentColor"
							viewBox="0 0 24 24"
						>
							<path
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M3 6l3 1m0 0l-3 9a5.002 5.002 0 006.001 0M6 7l3 9M6 7l6-2m6 2l3-1m-3 1l-3 9a5.002 5.002 0 006.001 0M18 7l3 9m-3-9l-6-2m0-2v2m0 16V5m0 16H9m3 0h3"
							/>
						</svg>
					</div>
					<h3 class="text-lg font-semibold text-gray-900">Legal Registers</h3>
				</div>
				<p class="text-sm text-gray-600 mb-4">
					Browse 19,000+ UK legal and regulatory records covering health &amp; safety and
					environmental legislation. Includes primary and secondary law, statutory instruments, and
					regulations.
				</p>
				<ul class="space-y-2 text-sm text-gray-600">
					<li class="flex items-start gap-2">
						<svg
							class="w-4 h-4 text-emerald-500 mt-0.5 shrink-0"
							fill="none"
							stroke="currentColor"
							viewBox="0 0 24 24"
						>
							<path
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M5 13l4 4L19 7"
							/>
						</svg>
						UK Legal Register Transport (LRT) &mdash; full dataset
					</li>
					<li class="flex items-start gap-2">
						<svg
							class="w-4 h-4 text-emerald-500 mt-0.5 shrink-0"
							fill="none"
							stroke="currentColor"
							viewBox="0 0 24 24"
						>
							<path
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M5 13l4 4L19 7"
							/>
						</svg>
						Legislation families, extents, and amendments
					</li>
					<li class="flex items-start gap-2">
						<svg
							class="w-4 h-4 text-emerald-500 mt-0.5 shrink-0"
							fill="none"
							stroke="currentColor"
							viewBox="0 0 24 24"
						>
							<path
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M5 13l4 4L19 7"
							/>
						</svg>
						Duty holder, power holder, and rights holder classifications
					</li>
				</ul>
			</div>

			<!-- Enforcement -->
			<div class="bg-white rounded-lg shadow-lg p-6 border-t-4 border-amber-500">
				<div class="flex items-center gap-3 mb-4">
					<div class="w-10 h-10 bg-amber-100 rounded-lg flex items-center justify-center">
						<svg
							class="w-6 h-6 text-amber-600"
							fill="none"
							stroke="currentColor"
							viewBox="0 0 24 24"
						>
							<path
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"
							/>
						</svg>
					</div>
					<h3 class="text-lg font-semibold text-gray-900">Enforcement Data</h3>
				</div>
				<p class="text-sm text-gray-600 mb-4">
					Track enforcement actions across UK regulatory bodies including HSE, Environment Agency,
					SEPA, and NRW. Monitor cases, notices, and prosecutions.
				</p>
				<ul class="space-y-2 text-sm text-gray-600">
					<li class="flex items-start gap-2">
						<svg
							class="w-4 h-4 text-emerald-500 mt-0.5 shrink-0"
							fill="none"
							stroke="currentColor"
							viewBox="0 0 24 24"
						>
							<path
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M5 13l4 4L19 7"
							/>
						</svg>
						Enforcement cases, notices, and offender records
					</li>
					<li class="flex items-start gap-2">
						<svg
							class="w-4 h-4 text-emerald-500 mt-0.5 shrink-0"
							fill="none"
							stroke="currentColor"
							viewBox="0 0 24 24"
						>
							<path
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M5 13l4 4L19 7"
							/>
						</svg>
						Legislation and offence reference data
					</li>
					<li class="flex items-start gap-2">
						<svg
							class="w-4 h-4 text-emerald-500 mt-0.5 shrink-0"
							fill="none"
							stroke="currentColor"
							viewBox="0 0 24 24"
						>
							<path
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M5 13l4 4L19 7"
							/>
						</svg>
						Multi-agency coverage: HSE, EA, SEPA, NRW
					</li>
				</ul>
			</div>
		</div>
	</section>

	<!-- Features -->
	<section class="bg-white border-y border-gray-200">
		<div class="max-w-5xl mx-auto px-4 py-16">
			<h2 class="text-2xl font-bold text-gray-900 text-center mb-3">
				How You'll Work With the Data
			</h2>
			<p class="text-center text-gray-500 mb-12 max-w-2xl mx-auto">
				Blanket Bog isn't just read access to a database. It's a full-featured data workspace
				powered by local-first technology.
			</p>

			<div class="grid grid-cols-1 md:grid-cols-2 gap-10">
				<!-- Table Views -->
				<div class="flex gap-4">
					<div
						class="w-10 h-10 bg-emerald-100 rounded-lg flex items-center justify-center shrink-0"
					>
						<svg
							class="w-5 h-5 text-emerald-600"
							fill="none"
							stroke="currentColor"
							viewBox="0 0 24 24"
						>
							<path
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M3 10h18M3 14h18m-9-4v8m-7 0h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z"
							/>
						</svg>
					</div>
					<div>
						<h3 class="font-semibold text-gray-900 mb-1">Interactive Table Views</h3>
						<p class="text-sm text-gray-600">
							An Airtable-like experience for browsing compliance data. Sort, filter, group, and
							customise column layouts. Resize columns, reorder views, and save your preferred
							configurations. Powered by svelte-table-kit.
						</p>
					</div>
				</div>

				<!-- Local-First Speed -->
				<div class="flex gap-4">
					<div
						class="w-10 h-10 bg-emerald-100 rounded-lg flex items-center justify-center shrink-0"
					>
						<svg
							class="w-5 h-5 text-emerald-600"
							fill="none"
							stroke="currentColor"
							viewBox="0 0 24 24"
						>
							<path
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M13 10V3L4 14h7v7l9-11h-7z"
							/>
						</svg>
					</div>
					<div>
						<h3 class="font-semibold text-gray-900 mb-1">Local-First Speed</h3>
						<p class="text-sm text-gray-600">
							Data syncs to your device via ElectricSQL and lives in a local store. Filtering,
							sorting, and searching happen instantly with zero network latency. The data is always
							there, even when your connection isn't.
						</p>
					</div>
				</div>

				<!-- Notifications -->
				<div class="flex gap-4">
					<div
						class="w-10 h-10 bg-emerald-100 rounded-lg flex items-center justify-center shrink-0"
					>
						<svg
							class="w-5 h-5 text-emerald-600"
							fill="none"
							stroke="currentColor"
							viewBox="0 0 24 24"
						>
							<path
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"
							/>
						</svg>
					</div>
					<div>
						<h3 class="font-semibold text-gray-900 mb-1">Change Notifications</h3>
						<p class="text-sm text-gray-600">
							Set up custom alerts for the data that matters to you. Get notified when new
							enforcement actions are published, legislation is amended, or records matching your
							criteria change. Stay ahead of regulatory shifts.
						</p>
					</div>
				</div>

				<!-- AI Queries -->
				<div class="flex gap-4">
					<div
						class="w-10 h-10 bg-emerald-100 rounded-lg flex items-center justify-center shrink-0"
					>
						<svg
							class="w-5 h-5 text-emerald-600"
							fill="none"
							stroke="currentColor"
							viewBox="0 0 24 24"
						>
							<path
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"
							/>
						</svg>
					</div>
					<div>
						<h3 class="font-semibold text-gray-900 mb-1">AI-Supported Queries</h3>
						<p class="text-sm text-gray-600">
							Ask questions in plain English. "Show me all HSE enforcement notices in manufacturing
							from the last year" or "Which environmental regulations apply to waste management in
							Scotland?" The AI translates your intent into precise data queries.
						</p>
					</div>
				</div>
			</div>
		</div>
	</section>

	<!-- Why it's named Blanket Bog -->
	<section class="max-w-3xl mx-auto px-4 py-16 text-center">
		<h2 class="text-2xl font-bold text-gray-900 mb-4">Why "Blanket Bog"?</h2>
		<p class="text-gray-600 leading-relaxed">
			Our plans are named after UK habitats, from common to rare. Blanket bogs are one of the most
			widespread and ecologically important landscapes in the UK &mdash; vast, open, and freely
			accessible. Like blanket bog, this tier is the foundation: essential, available to everyone,
			and quietly vital.
		</p>
	</section>

	<!-- CTA -->
	<section class="bg-emerald-700 text-white">
		<div class="max-w-3xl mx-auto px-4 py-12 text-center">
			<h2 class="text-2xl font-bold mb-3">Ready to explore?</h2>
			<p class="text-emerald-100 mb-6">
				Create a free account to start using Blanket Bog. No credit card, no commitment.
			</p>
			<div class="flex flex-col sm:flex-row gap-4 justify-center">
				{#if $authStore.isAuthenticated}
					<button
						on:click={() => goto('/dashboard')}
						class="px-6 py-3 bg-white text-emerald-700 font-semibold rounded-lg hover:bg-emerald-50 transition-colors duration-200"
					>
						Go to Dashboard
					</button>
				{:else}
					<a
						href="/register"
						class="px-6 py-3 bg-white text-emerald-700 font-semibold rounded-lg hover:bg-emerald-50 transition-colors duration-200"
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

	<!-- Compare Plans -->
	<section class="max-w-5xl mx-auto px-4 py-12 text-center">
		<p class="text-gray-500 text-sm">
			Need more? Compare plans:
			<a href="/flower-meadow" class="text-emerald-600 hover:text-emerald-700 font-medium"
				>Flower Meadow</a
			>
			&middot;
			<a href="/atlantic-rainforest" class="text-emerald-600 hover:text-emerald-700 font-medium"
				>Atlantic Rainforest</a
			>
		</p>
	</section>
</main>
