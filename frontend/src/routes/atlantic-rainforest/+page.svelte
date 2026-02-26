<script lang="ts">
	import { authStore } from '$lib/stores/auth';
	import { goto } from '$app/navigation';
</script>

<main class="min-h-screen bg-gray-50">
	<!-- Hero -->
	<section
		style="background: linear-gradient(to bottom right, #065f46, #022c22);"
		class="text-white"
	>
		<div class="max-w-5xl mx-auto px-4 py-16 sm:py-20 text-center">
			<span
				class="inline-block px-3 py-1 mb-4 text-sm font-medium bg-white/15 rounded-full backdrop-blur-sm"
			>
				Enterprise Tier
			</span>
			<h1 class="text-4xl sm:text-5xl font-bold tracking-tight mb-4">Atlantic Rainforest</h1>
			<p class="text-xl sm:text-2xl font-light text-emerald-100 mb-6">
				Compliance data, piped into your own tools
			</p>
			<p class="max-w-2xl mx-auto text-emerald-200 leading-relaxed">
				Choose the legal and enforcement datasets you need. Sync them into open-source
				database-as-tables platforms like Baserow, NocoDB, or Grist. Build your own compliance
				solutions on top &mdash; SertantAI keeps the data current.
			</p>
			<div class="mt-8 flex flex-col sm:flex-row gap-4 justify-center">
				{#if $authStore.isAuthenticated}
					<button
						on:click={() => goto('/dashboard')}
						style="color: #065f46;"
						class="px-6 py-3 bg-white font-semibold rounded-lg hover:bg-emerald-50 transition-colors duration-200"
					>
						Go to Dashboard
					</button>
				{:else}
					<a
						href="/register"
						style="color: #065f46;"
						class="px-6 py-3 bg-white font-semibold rounded-lg hover:bg-emerald-50 transition-colors duration-200"
					>
						Get Started
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

	<!-- How It Works -->
	<section class="max-w-5xl mx-auto px-4 py-16">
		<h2 class="text-2xl font-bold text-gray-900 text-center mb-3">How It Works</h2>
		<p class="text-center text-gray-500 mb-12 max-w-2xl mx-auto">
			Three steps. Pick your data, connect your platform, and let SertantAI keep it fresh.
		</p>

		<div class="grid grid-cols-1 md:grid-cols-3 gap-8">
			<!-- Step 1 -->
			<div class="text-center">
				<div
					class="w-12 h-12 bg-emerald-100 rounded-full flex items-center justify-center mx-auto mb-4"
				>
					<span class="text-lg font-bold text-emerald-700">1</span>
				</div>
				<h3 class="font-semibold text-gray-900 mb-2">Choose Your Datasets</h3>
				<p class="text-sm text-gray-600">
					Browse the SertantAI catalogue. Select the legal registers, enforcement records,
					legislation families, or regulatory bodies relevant to your work. Sync only what you need.
				</p>
			</div>

			<!-- Step 2 -->
			<div class="text-center">
				<div
					class="w-12 h-12 bg-emerald-100 rounded-full flex items-center justify-center mx-auto mb-4"
				>
					<span class="text-lg font-bold text-emerald-700">2</span>
				</div>
				<h3 class="font-semibold text-gray-900 mb-2">Connect Your Platform</h3>
				<p class="text-sm text-gray-600">
					Link your Baserow, NocoDB, Grist, or other database-as-tables instance. SertantAI creates
					the tables and populates them with your selected data.
				</p>
			</div>

			<!-- Step 3 -->
			<div class="text-center">
				<div
					class="w-12 h-12 bg-emerald-100 rounded-full flex items-center justify-center mx-auto mb-4"
				>
					<span class="text-lg font-bold text-emerald-700">3</span>
				</div>
				<h3 class="font-semibold text-gray-900 mb-2">Stay Current</h3>
				<p class="text-sm text-gray-600">
					SertantAI monitors for changes &mdash; new legislation, amended regulations, enforcement
					actions. Your tables update automatically on the schedule you set.
				</p>
			</div>
		</div>
	</section>

	<!-- Available Datasets -->
	<section class="bg-white border-y border-gray-200">
		<div class="max-w-5xl mx-auto px-4 py-16">
			<h2 class="text-2xl font-bold text-gray-900 text-center mb-3">Available Datasets</h2>
			<p class="text-center text-gray-500 mb-10 max-w-2xl mx-auto">
				Curated from SertantAI's legal and enforcement services. Pick whole datasets or filter by
				jurisdiction, family, or regulatory body.
			</p>

			<div class="grid grid-cols-1 md:grid-cols-2 gap-8">
				<!-- Legal Data -->
				<div class="bg-gray-50 rounded-lg p-6">
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
							<span><strong>UK LRT</strong> &mdash; 19,000+ legal and regulatory records</span>
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
							<span
								><strong>Legislation families</strong> &mdash; OH&S, Environment, Energy, Pollution,
								and more</span
							>
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
							<span
								><strong>Holder classifications</strong> &mdash; duty holders, power holders, rights
								holders</span
							>
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
							<span
								><strong>Amendment chains</strong> &mdash; track how legislation has been amended over
								time</span
							>
						</li>
					</ul>
				</div>

				<!-- Enforcement Data -->
				<div class="bg-gray-50 rounded-lg p-6">
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
							<span
								><strong>Cases &amp; prosecutions</strong> &mdash; across HSE, EA, SEPA, NRW</span
							>
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
							<span
								><strong>Enforcement notices</strong> &mdash; improvement, prohibition, and remediation</span
							>
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
							<span
								><strong>Offender records</strong> &mdash; businesses and individuals subject to enforcement</span
							>
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
							<span
								><strong>Legislation &amp; offences</strong> &mdash; reference data linking enforcement
								to law</span
							>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</section>

	<!-- Supported Platforms -->
	<section class="max-w-5xl mx-auto px-4 py-16">
		<h2 class="text-2xl font-bold text-gray-900 text-center mb-3">Open-Source Platforms</h2>
		<p class="text-center text-gray-500 mb-10 max-w-2xl mx-auto">
			Sync to any open-source database-as-tables platform. Your data, your instance, your
			infrastructure.
		</p>

		<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
			<!-- Baserow -->
			<div class="bg-white rounded-lg shadow-lg p-6 border border-gray-200">
				<h3 class="font-semibold text-gray-900 mb-2">Baserow</h3>
				<p class="text-sm text-gray-600 mb-3">
					Self-hosted Airtable alternative. Spreadsheet-database hybrid with a powerful API. Build
					views, forms, and automations on top of SertantAI data.
				</p>
				<span
					class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-emerald-100 text-emerald-800"
				>
					Supported
				</span>
			</div>

			<!-- NocoDB -->
			<div class="bg-white rounded-lg shadow-lg p-6 border border-gray-200">
				<h3 class="font-semibold text-gray-900 mb-2">NocoDB</h3>
				<p class="text-sm text-gray-600 mb-3">
					Open-source smart spreadsheet that turns any database into a collaborative workspace.
					Supports views, filters, formulas, and API access.
				</p>
				<span
					class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-emerald-100 text-emerald-800"
				>
					Supported
				</span>
			</div>

			<!-- Grist -->
			<div class="bg-white rounded-lg shadow-lg p-6 border border-gray-200">
				<h3 class="font-semibold text-gray-900 mb-2">Grist</h3>
				<p class="text-sm text-gray-600 mb-3">
					Modern, open-source spreadsheet with full Python formula support. Ideal for teams that
					need custom logic and complex data relationships.
				</p>
				<span
					class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-emerald-100 text-emerald-800"
				>
					Supported
				</span>
			</div>
		</div>

		<p class="text-center text-gray-400 text-xs mt-6">
			Additional platforms available via REST API integration. Contact us for custom connectors.
		</p>
	</section>

	<!-- Sync Features -->
	<section class="bg-white border-y border-gray-200">
		<div class="max-w-5xl mx-auto px-4 py-16">
			<h2 class="text-2xl font-bold text-gray-900 text-center mb-3">Sync That Works For You</h2>
			<p class="text-center text-gray-500 mb-12 max-w-2xl mx-auto">
				Configure once and forget about it. Or fine-tune to match your workflow.
			</p>

			<div class="grid grid-cols-1 md:grid-cols-2 gap-10">
				<!-- Selective Sync -->
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
								d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z"
							/>
						</svg>
					</div>
					<div>
						<h3 class="font-semibold text-gray-900 mb-1">Selective Sync</h3>
						<p class="text-sm text-gray-600">
							Pick exactly the data you need. Filter by legislation family, jurisdiction, regulatory
							body, or date range. Sync whole tables or specific subsets.
						</p>
					</div>
				</div>

				<!-- Scheduled Updates -->
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
								d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
							/>
						</svg>
					</div>
					<div>
						<h3 class="font-semibold text-gray-900 mb-1">Scheduled Updates</h3>
						<p class="text-sm text-gray-600">
							Set your sync frequency: manual, hourly, daily, or weekly. SertantAI pushes changes on
							schedule &mdash; new records, amendments, and status updates arrive automatically.
						</p>
					</div>
				</div>

				<!-- Rate-Limited & Reliable -->
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
								d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"
							/>
						</svg>
					</div>
					<div>
						<h3 class="font-semibold text-gray-900 mb-1">Rate-Limited &amp; Reliable</h3>
						<p class="text-sm text-gray-600">
							Built-in rate limiting respects your platform's API limits. Failed syncs retry
							automatically. Encrypted credentials stored securely. Full sync history and status
							tracking.
						</p>
					</div>
				</div>

				<!-- Build Your Own -->
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
								d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4"
							/>
						</svg>
					</div>
					<div>
						<h3 class="font-semibold text-gray-900 mb-1">Build Your Own Solutions</h3>
						<p class="text-sm text-gray-600">
							The data lands in your platform as structured tables. From there, use your platform's
							native tools &mdash; views, filters, formulas, automations, dashboards &mdash; to
							build the compliance workflows your organisation needs.
						</p>
					</div>
				</div>
			</div>
		</div>
	</section>

	<!-- Use Cases -->
	<section class="max-w-5xl mx-auto px-4 py-16">
		<h2 class="text-2xl font-bold text-gray-900 text-center mb-3">What You Can Build</h2>
		<p class="text-center text-gray-500 mb-10 max-w-2xl mx-auto">
			SertantAI provides the data. Your platform provides the workspace. Here's what teams are
			building.
		</p>

		<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
			<div class="border border-gray-200 rounded-lg p-5">
				<h3 class="font-semibold text-gray-900 text-sm mb-2">Legal Registers</h3>
				<p class="text-xs text-gray-600">
					Maintain a live register of applicable legislation for your sites. Filter by jurisdiction
					and family. Link to internal controls and evidence.
				</p>
			</div>

			<div class="border border-gray-200 rounded-lg p-5">
				<h3 class="font-semibold text-gray-900 text-sm mb-2">Enforcement Monitoring</h3>
				<p class="text-xs text-gray-600">
					Track enforcement actions in your sector. Build views filtered by industry, regulatory
					body, or offence type. Set up alerts for new actions.
				</p>
			</div>

			<div class="border border-gray-200 rounded-lg p-5">
				<h3 class="font-semibold text-gray-900 text-sm mb-2">Compliance Dashboards</h3>
				<p class="text-xs text-gray-600">
					Create visual dashboards combining SertantAI data with your internal compliance records.
					Track gaps, deadlines, and regulatory changes.
				</p>
			</div>

			<div class="border border-gray-200 rounded-lg p-5">
				<h3 class="font-semibold text-gray-900 text-sm mb-2">Audit Preparation</h3>
				<p class="text-xs text-gray-600">
					Pull applicable legislation into audit workbooks. Cross-reference with enforcement
					history. Generate evidence trackers linked to specific regulations.
				</p>
			</div>

			<div class="border border-gray-200 rounded-lg p-5">
				<h3 class="font-semibold text-gray-900 text-sm mb-2">Regulatory Change Tracking</h3>
				<p class="text-xs text-gray-600">
					Monitor legislative amendments as they happen. Use platform automations to notify
					stakeholders and create review tasks when relevant laws change.
				</p>
			</div>

			<div class="border border-gray-200 rounded-lg p-5">
				<h3 class="font-semibold text-gray-900 text-sm mb-2">Training Records</h3>
				<p class="text-xs text-gray-600">
					Link training requirements to specific legislation. Track completion against regulatory
					obligations. Identify gaps when new regulations come into force.
				</p>
			</div>
		</div>
	</section>

	<!-- Why Atlantic Rainforest -->
	<section class="bg-white border-t border-gray-200">
		<div class="max-w-3xl mx-auto px-4 py-16 text-center">
			<h2 class="text-2xl font-bold text-gray-900 mb-4">Why "Atlantic Rainforest"?</h2>
			<p class="text-gray-600 leading-relaxed">
				Britain's Atlantic rainforests are among the rarest habitats on earth &mdash; temperate
				rainforest clinging to the western coasts of Scotland, Wales, and southwest England.
				Ancient, irreplaceable ecosystems of extraordinary complexity. Like the rainforest, this
				tier is about building rich, interconnected systems from living data &mdash; where every
				connection matters and the whole is greater than the parts.
			</p>
		</div>
	</section>

	<!-- CTA -->
	<section style="background-color: #065f46;" class="text-white">
		<div class="max-w-3xl mx-auto px-4 py-12 text-center">
			<h2 class="text-2xl font-bold mb-3">Build compliance your way</h2>
			<p class="text-emerald-200 mb-6">
				Connect your open-source platform and start syncing regulatory data today.
			</p>
			<div class="flex flex-col sm:flex-row gap-4 justify-center">
				{#if $authStore.isAuthenticated}
					<button
						on:click={() => goto('/dashboard')}
						style="color: #065f46;"
						class="px-6 py-3 bg-white font-semibold rounded-lg hover:bg-emerald-50 transition-colors duration-200"
					>
						Go to Dashboard
					</button>
				{:else}
					<a
						href="/register"
						style="color: #065f46;"
						class="px-6 py-3 bg-white font-semibold rounded-lg hover:bg-emerald-50 transition-colors duration-200"
					>
						Get Started
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
			Compare plans:
			<a href="/blanket-bog" class="text-emerald-600 hover:text-emerald-700 font-medium"
				>Blanket Bog</a
			>
			<span class="text-gray-300">(Free)</span>
			&middot;
			<a href="/flower-meadow" class="text-emerald-600 hover:text-emerald-700 font-medium"
				>Flower Meadow</a
			>
			<span class="text-gray-300">(Professional)</span>
		</p>
	</section>
</main>
