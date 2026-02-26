<script lang="ts">
	import { authStore } from '$lib/stores/auth';
	import { goto } from '$app/navigation';
</script>

<main class="min-h-screen bg-gray-50">
	<!-- Header -->
	<section class="bg-white border-b border-gray-200">
		<div class="max-w-5xl mx-auto px-4 py-16 text-center">
			<h1 class="text-4xl font-bold text-gray-900 mb-4">Pricing</h1>
			<p class="text-lg text-gray-500 max-w-2xl mx-auto">
				SertantAI is a not-for-profit. Free core access for everyone. Premium tiers fund micro urban
				community environmental projects.
			</p>
		</div>
	</section>

	<!-- Pricing Cards -->
	<section class="max-w-5xl mx-auto px-4 py-16">
		<div class="grid grid-cols-1 md:grid-cols-3 gap-8">
			<!-- Blanket Bog -->
			<div class="bg-white rounded-lg shadow-lg overflow-hidden border border-gray-200">
				<div class="p-6">
					<span
						class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-emerald-100 text-emerald-800 mb-3"
					>
						Free
					</span>
					<h2 class="text-xl font-bold text-gray-900 mb-1">Blanket Bog</h2>
					<p class="text-sm text-gray-500 mb-4">Core compliance intelligence</p>

					<div class="mb-6">
						<span class="text-4xl font-bold text-gray-900">$0</span>
						<span class="text-gray-500">/month</span>
					</div>

					{#if $authStore.isAuthenticated}
						<button
							on:click={() => goto('/dashboard')}
							class="w-full px-4 py-2.5 bg-gray-100 text-gray-700 font-semibold rounded-lg hover:bg-gray-200 transition-colors duration-200"
						>
							Current Plan
						</button>
					{:else}
						<a
							href="/register"
							class="block w-full px-4 py-2.5 bg-gray-900 text-white font-semibold rounded-lg hover:bg-gray-800 transition-colors duration-200 text-center"
						>
							Create Free Account
						</a>
					{/if}
				</div>

				<div class="border-t border-gray-200 p-6">
					<p class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-4">Includes</p>
					<ul class="space-y-3 text-sm text-gray-600">
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
							19,000+ UK legal register records
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
							UK enforcement data (HSE, EA, SEPA, NRW)
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
							Interactive table views (svelte-table-kit)
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
							Local-first speed (ElectricSQL)
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
							Custom change notifications
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
							AI-supported queries
						</li>
					</ul>
				</div>

				<div class="border-t border-gray-200 px-6 py-4">
					<a href="/blanket-bog" class="text-sm text-blue-600 hover:text-blue-700 font-medium"
						>Learn more &rarr;</a
					>
				</div>
			</div>

			<!-- Atlantic Rainforest -->
			<div class="bg-white rounded-lg shadow-lg overflow-hidden border border-gray-200">
				<div class="p-6">
					<span
						style="background-color: #d1fae5; color: #065f46;"
						class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium mb-3"
					>
						Enterprise
					</span>
					<h2 class="text-xl font-bold text-gray-900 mb-1">Atlantic Rainforest</h2>
					<p class="text-sm text-gray-500 mb-4">Sync data to your own tools</p>

					<div class="mb-6">
						<span class="text-4xl font-bold text-gray-900">$9</span>
						<span class="text-gray-500">/user/month</span>
					</div>

					<a
						href="/register"
						style="background-color: #065f46;"
						class="block w-full px-4 py-2.5 text-white font-semibold rounded-lg hover:opacity-90 transition-opacity duration-200 text-center"
					>
						Get Started
					</a>
				</div>

				<div class="border-t border-gray-200 p-6">
					<p class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-4">
						Everything in Blanket Bog, plus
					</p>
					<ul class="space-y-3 text-sm text-gray-600">
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
							Sync to Baserow, NocoDB, or Grist
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
							Selective dataset sync
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
							Scheduled auto-updates (hourly/daily/weekly)
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
							REST API for custom integrations
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
							Build your own compliance workflows
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
							Encrypted credential storage
						</li>
					</ul>
				</div>

				<div class="border-t border-gray-200 px-6 py-4">
					<a
						href="/atlantic-rainforest"
						class="text-sm text-blue-600 hover:text-blue-700 font-medium">Learn more &rarr;</a
					>
				</div>
			</div>

			<!-- Flower Meadow -->
			<div
				class="bg-white rounded-lg shadow-xl overflow-hidden border-2"
				style="border-color: #6b21a8;"
			>
				<div
					style="background: linear-gradient(to right, #6b21a8, #4c1d95);"
					class="px-6 py-2 text-center"
				>
					<span class="text-xs font-semibold text-white uppercase tracking-wide">Most Capable</span>
				</div>
				<div class="p-6">
					<span
						style="background-color: #f3e8ff; color: #6b21a8;"
						class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium mb-3"
					>
						Professional
					</span>
					<h2 class="text-xl font-bold text-gray-900 mb-1">Flower Meadow</h2>
					<p class="text-sm text-gray-500 mb-4">P2P platform with local AI</p>

					<div class="mb-6">
						<span class="text-4xl font-bold text-gray-900">$29</span>
						<span class="text-gray-500">/user/month</span>
					</div>

					<a
						href="/register"
						style="background-color: #6b21a8;"
						class="block w-full px-4 py-2.5 text-white font-semibold rounded-lg hover:opacity-90 transition-opacity duration-200 text-center"
					>
						Get Started
					</a>
				</div>

				<div class="border-t border-gray-200 p-6">
					<p class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-4">
						Everything in Blanket Bog, plus
					</p>
					<ul class="space-y-3 text-sm text-gray-600">
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
							Hive-Bee P2P data sync
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
							AI micro-apps (field research, gap analysis, incident classifier, and more)
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
							Offline AI with local ONNX models
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
							Data sovereignty (zero cloud or bring your own Hive)
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
							CRDT conflict-free collaboration
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
							Hash-chained immutable audit trail
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
							WebAssembly sandboxed execution
						</li>
					</ul>
				</div>

				<div class="border-t border-gray-200 px-6 py-4">
					<a href="/flower-meadow" class="text-sm text-blue-600 hover:text-blue-700 font-medium"
						>Learn more &rarr;</a
					>
				</div>
			</div>
		</div>

		<p class="text-center text-gray-400 text-xs mt-8">
			All prices exclude VAT. Annual billing available at a 20% discount.
		</p>
	</section>

	<!-- FAQ -->
	<section class="bg-white border-y border-gray-200">
		<div class="max-w-3xl mx-auto px-4 py-16">
			<h2 class="text-2xl font-bold text-gray-900 text-center mb-10">Common Questions</h2>

			<div class="space-y-8">
				<div>
					<h3 class="font-semibold text-gray-900 mb-2">Is Blanket Bog really free?</h3>
					<p class="text-sm text-gray-600">
						Yes. SertantAI is a not-for-profit. Blanket Bog gives every registered user full read
						access to our curated legal and enforcement datasets with interactive tables, AI
						queries, and local-first speed. No credit card required, no time limit. Our data is your
						data under a liberal creative commons licence.
					</p>
				</div>

				<div>
					<h3 class="font-semibold text-gray-900 mb-2">
						What's the difference between Atlantic Rainforest and Flower Meadow?
					</h3>
					<p class="text-sm text-gray-600">
						Atlantic Rainforest syncs SertantAI data into your existing open-source platform
						(Baserow, NocoDB, Grist) so you can build your own workflows. Flower Meadow is a full
						peer-to-peer platform with AI micro-apps that run directly on your device &mdash; no
						cloud, offline capable, with data sovereignty built in.
					</p>
				</div>

				<div>
					<h3 class="font-semibold text-gray-900 mb-2">Can I switch plans?</h3>
					<p class="text-sm text-gray-600">
						Yes. You can upgrade or downgrade at any time. Changes take effect at the start of your
						next billing cycle. Downgrading to Blanket Bog is always free.
					</p>
				</div>

				<div>
					<h3 class="font-semibold text-gray-900 mb-2">Do you offer annual billing?</h3>
					<p class="text-sm text-gray-600">
						Yes. Annual billing is available at a 20% discount. Atlantic Rainforest is $86/year per
						user. Flower Meadow is $278/year per user.
					</p>
				</div>

				<div>
					<h3 class="font-semibold text-gray-900 mb-2">What data is included in all plans?</h3>
					<p class="text-sm text-gray-600">
						All plans include the full UK Legal Register Transport (19,000+ records) and enforcement
						data from HSE, Environment Agency, SEPA, and NRW. This covers cases, notices, offender
						records, legislation, and offence reference data.
					</p>
				</div>

				<div>
					<h3 class="font-semibold text-gray-900 mb-2">Where does the money go?</h3>
					<p class="text-sm text-gray-600">
						Revenue from premium tiers funds platform development and supports micro urban community
						environmental projects. We work towards 100% of surplus income funding community work.
						No profit extraction &mdash; every pound goes back into the mission.
					</p>
				</div>

				<div>
					<h3 class="font-semibold text-gray-900 mb-2">
						I need a plan for my whole organisation. Do you offer volume pricing?
					</h3>
					<p class="text-sm text-gray-600">
						Yes. Contact us for volume pricing on teams of 10 or more. We also offer dedicated Hive
						instances for organisations with specific data sovereignty requirements.
					</p>
				</div>
			</div>
		</div>
	</section>

	<!-- Footer CTA -->
	<section class="max-w-3xl mx-auto px-4 py-16 text-center">
		<p class="text-gray-600 mb-4">Not sure which plan is right for you?</p>
		<p class="text-sm text-gray-500">
			Start with
			<a href="/blanket-bog" class="text-blue-600 hover:text-blue-700 font-medium">Blanket Bog</a>
			for free and upgrade when you're ready.
		</p>
	</section>
</main>
