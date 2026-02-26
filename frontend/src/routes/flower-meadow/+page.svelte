<script lang="ts">
	import { authStore } from '$lib/stores/auth';
	import { goto } from '$app/navigation';
</script>

<main class="min-h-screen bg-gray-50">
	<!-- Hero -->
	<section
		style="background: linear-gradient(to bottom right, #6b21a8, #1e1b4b);"
		class="text-white"
	>
		<div class="max-w-5xl mx-auto px-4 py-16 sm:py-20 text-center">
			<span
				class="inline-block px-3 py-1 mb-4 text-sm font-medium bg-white/15 rounded-full backdrop-blur-sm"
			>
				Professional Tier
			</span>
			<h1 class="text-4xl sm:text-5xl font-bold tracking-tight mb-4">Flower Meadow</h1>
			<p class="text-xl sm:text-2xl font-light text-purple-100 mb-6">
				Your data. Your device. Your AI. Zero cloud.
			</p>
			<p class="max-w-2xl mx-auto text-purple-200 leading-relaxed">
				A peer-to-peer compliance platform that syncs directly to your device. Focused AI micro-apps
				run locally, your data never leaves your control, and everything works at the speed of local
				storage &mdash; not network round-trips.
			</p>
			<div class="mt-8 flex flex-col sm:flex-row gap-4 justify-center">
				{#if $authStore.isAuthenticated}
					<button
						on:click={() => goto('/dashboard')}
						class="px-6 py-3 bg-white text-purple-800 font-semibold rounded-lg hover:bg-purple-50 transition-colors duration-200"
					>
						Go to Dashboard
					</button>
				{:else}
					<a
						href="/register"
						class="px-6 py-3 bg-white text-purple-800 font-semibold rounded-lg hover:bg-purple-50 transition-colors duration-200"
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

	<!-- The Big Idea -->
	<section class="max-w-5xl mx-auto px-4 py-16">
		<h2 class="text-2xl font-bold text-gray-900 text-center mb-3">The Architecture</h2>
		<p class="text-center text-gray-500 mb-10 max-w-3xl mx-auto">
			Flower Meadow is built on a Hive-Bee peer-to-peer model. SertantAI runs the Hive &mdash;
			curated datasets, governance, and AI processing. Your device is the Bee. Plug in, switch on,
			and P2P sync delivers everything you need. No cloud servers in between.
		</p>

		<div class="grid grid-cols-1 md:grid-cols-3 gap-6">
			<!-- Hive -->
			<div class="bg-white rounded-lg shadow-lg p-6 border-t-4 border-purple-500">
				<div class="flex items-center gap-3 mb-4">
					<div class="w-10 h-10 bg-purple-100 rounded-lg flex items-center justify-center">
						<svg
							class="w-6 h-6 text-purple-600"
							fill="none"
							stroke="currentColor"
							viewBox="0 0 24 24"
						>
							<path
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"
							/>
						</svg>
					</div>
					<h3 class="text-lg font-semibold text-gray-900">The Hive</h3>
				</div>
				<p class="text-sm text-gray-600">
					SertantAI's hub. Curated UK legal registers, enforcement data, AI-polished annotations,
					and classification centroids. The source of truth for compliance intelligence.
				</p>
			</div>

			<!-- P2P Sync -->
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
								d="M8 7h12m0 0l-4-4m4 4l-4 4m0 6H4m0 0l4 4m-4-4l4-4"
							/>
						</svg>
					</div>
					<h3 class="text-lg font-semibold text-gray-900">P2P Sync</h3>
				</div>
				<p class="text-sm text-gray-600">
					Zenoh-powered mesh networking. Automatic discovery, intermittent connectivity, and
					conflict-free data merge via CRDTs. Data flows directly between peers &mdash; no central
					server bottleneck.
				</p>
			</div>

			<!-- Bee -->
			<div class="bg-white rounded-lg shadow-lg p-6 border-t-4 border-emerald-500">
				<div class="flex items-center gap-3 mb-4">
					<div class="w-10 h-10 bg-emerald-100 rounded-lg flex items-center justify-center">
						<svg
							class="w-6 h-6 text-emerald-600"
							fill="none"
							stroke="currentColor"
							viewBox="0 0 24 24"
						>
							<path
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
							/>
						</svg>
					</div>
					<h3 class="text-lg font-semibold text-gray-900">Your Bee</h3>
				</div>
				<p class="text-sm text-gray-600">
					Your laptop, tablet, or workstation. Runs AI micro-apps locally with a synced data slice.
					Search, classify, and query compliance data at the speed of your own hardware.
				</p>
			</div>
		</div>
	</section>

	<!-- Micro-Apps -->
	<section class="bg-white border-y border-gray-200">
		<div class="max-w-5xl mx-auto px-4 py-16">
			<h2 class="text-2xl font-bold text-gray-900 text-center mb-3">AI Micro-Apps</h2>
			<p class="text-center text-gray-500 mb-12 max-w-3xl mx-auto">
				Not a monolithic platform. Each capability is an independently sandboxed AI tool that does
				one thing well, with exactly the data and model it needs. They run on your device, not in
				the cloud.
			</p>

			<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
				<!-- Field Research -->
				<div class="border border-gray-200 rounded-lg p-5">
					<div class="flex items-center gap-2 mb-3">
						<div class="w-8 h-8 bg-purple-100 rounded flex items-center justify-center">
							<svg
								class="w-4 h-4 text-purple-600"
								fill="none"
								stroke="currentColor"
								viewBox="0 0 24 24"
							>
								<path
									stroke-linecap="round"
									stroke-linejoin="round"
									stroke-width="2"
									d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
								/>
							</svg>
						</div>
						<h3 class="font-semibold text-gray-900 text-sm">Field Research</h3>
					</div>
					<p class="text-xs text-gray-600">
						On site and need to know what law applies? Ask in plain English. Semantic search runs
						locally against your synced legislation data &mdash; no network needed.
					</p>
				</div>

				<!-- Compliance Gap Analyser -->
				<div class="border border-gray-200 rounded-lg p-5">
					<div class="flex items-center gap-2 mb-3">
						<div class="w-8 h-8 bg-purple-100 rounded flex items-center justify-center">
							<svg
								class="w-4 h-4 text-purple-600"
								fill="none"
								stroke="currentColor"
								viewBox="0 0 24 24"
							>
								<path
									stroke-linecap="round"
									stroke-linejoin="round"
									stroke-width="2"
									d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"
								/>
							</svg>
						</div>
						<h3 class="font-semibold text-gray-900 text-sm">Compliance Gap Analysis</h3>
					</div>
					<p class="text-xs text-gray-600">
						Compare your site's permits and compliance records against applicable legislation.
						Identify gaps, rank by risk, and get suggested actions.
					</p>
				</div>

				<!-- Incident Classifier -->
				<div class="border border-gray-200 rounded-lg p-5">
					<div class="flex items-center gap-2 mb-3">
						<div class="w-8 h-8 bg-purple-100 rounded flex items-center justify-center">
							<svg
								class="w-4 h-4 text-purple-600"
								fill="none"
								stroke="currentColor"
								viewBox="0 0 24 24"
							>
								<path
									stroke-linecap="round"
									stroke-linejoin="round"
									stroke-width="2"
									d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
								/>
							</svg>
						</div>
						<h3 class="font-semibold text-gray-900 text-sm">Incident Classifier</h3>
					</div>
					<p class="text-xs text-gray-600">
						Describe an incident in natural language. AI classifies it by regulatory domain,
						severity, and applicable legislation &mdash; instantly, on your device.
					</p>
				</div>

				<!-- Audit Checklist -->
				<div class="border border-gray-200 rounded-lg p-5">
					<div class="flex items-center gap-2 mb-3">
						<div class="w-8 h-8 bg-purple-100 rounded flex items-center justify-center">
							<svg
								class="w-4 h-4 text-purple-600"
								fill="none"
								stroke="currentColor"
								viewBox="0 0 24 24"
							>
								<path
									stroke-linecap="round"
									stroke-linejoin="round"
									stroke-width="2"
									d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
								/>
							</svg>
						</div>
						<h3 class="font-semibold text-gray-900 text-sm">Audit Checklists</h3>
					</div>
					<p class="text-xs text-gray-600">
						Generate structured audit checklists from applicable legislation for a specific site and
						scope. Each item cites the legislation and duty holder.
					</p>
				</div>

				<!-- Obligation Tracker -->
				<div class="border border-gray-200 rounded-lg p-5">
					<div class="flex items-center gap-2 mb-3">
						<div class="w-8 h-8 bg-purple-100 rounded flex items-center justify-center">
							<svg
								class="w-4 h-4 text-purple-600"
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
						<h3 class="font-semibold text-gray-900 text-sm">Obligation Tracker</h3>
					</div>
					<p class="text-xs text-gray-600">
						Extracts time-bound obligations from legislation &mdash; deadlines, review periods,
						reporting dates. Tracks status and sends reminders.
					</p>
				</div>

				<!-- Penalty Researcher -->
				<div class="border border-gray-200 rounded-lg p-5">
					<div class="flex items-center gap-2 mb-3">
						<div class="w-8 h-8 bg-purple-100 rounded flex items-center justify-center">
							<svg
								class="w-4 h-4 text-purple-600"
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
						<h3 class="font-semibold text-gray-900 text-sm">Penalty Researcher</h3>
					</div>
					<p class="text-xs text-gray-600">
						Look up penalty provisions for any offence or regulation &mdash; fines, imprisonment
						terms, enforcement notice powers. Backed by enforcement data.
					</p>
				</div>
			</div>
		</div>
	</section>

	<!-- Data Sovereignty -->
	<section class="max-w-5xl mx-auto px-4 py-16">
		<h2 class="text-2xl font-bold text-gray-900 text-center mb-3">Data Sovereignty</h2>
		<p class="text-center text-gray-500 mb-10 max-w-3xl mx-auto">
			Two deployment models. Both keep you in control.
		</p>

		<div class="grid grid-cols-1 md:grid-cols-2 gap-8">
			<!-- Zero Cloud -->
			<div
				class="bg-gradient-to-br from-purple-50 to-white rounded-lg shadow-lg p-6 border border-purple-200"
			>
				<h3 class="text-lg font-semibold text-gray-900 mb-2">Zero Cloud</h3>
				<p class="text-sm text-gray-500 mb-4">Use SertantAI's Hive</p>
				<p class="text-sm text-gray-600 mb-4">
					SertantAI hosts the Hive. Your Bee syncs curated datasets and AI models directly via P2P.
					No cloud servers, no third-party infrastructure. Data flows peer-to-peer between the Hive
					and your device.
				</p>
				<ul class="space-y-2 text-sm text-gray-600">
					<li class="flex items-start gap-2">
						<svg
							class="w-4 h-4 text-purple-500 mt-0.5 shrink-0"
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
						Plug in and switch on &mdash; immediate sync
					</li>
					<li class="flex items-start gap-2">
						<svg
							class="w-4 h-4 text-purple-500 mt-0.5 shrink-0"
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
						Works offline after initial sync
					</li>
					<li class="flex items-start gap-2">
						<svg
							class="w-4 h-4 text-purple-500 mt-0.5 shrink-0"
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
						Automatic reconnect and catch-up
					</li>
				</ul>
			</div>

			<!-- Own Hive -->
			<div
				class="bg-gradient-to-br from-amber-50 to-white rounded-lg shadow-lg p-6 border border-amber-200"
			>
				<h3 class="text-lg font-semibold text-gray-900 mb-2">Bring Your Own Hive</h3>
				<p class="text-sm text-gray-500 mb-4">Full data sovereignty</p>
				<p class="text-sm text-gray-600 mb-4">
					Run your own Hive on your own infrastructure. Your data never touches SertantAI's network.
					Curated datasets sync to your Hive, then your Bees sync from there. Complete tenant
					isolation at the protocol level.
				</p>
				<ul class="space-y-2 text-sm text-gray-600">
					<li class="flex items-start gap-2">
						<svg
							class="w-4 h-4 text-amber-500 mt-0.5 shrink-0"
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
						Your server, your network, your rules
					</li>
					<li class="flex items-start gap-2">
						<svg
							class="w-4 h-4 text-amber-500 mt-0.5 shrink-0"
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
						Hermetic tenant isolation via protocol-level namespaces
					</li>
					<li class="flex items-start gap-2">
						<svg
							class="w-4 h-4 text-amber-500 mt-0.5 shrink-0"
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
						Sub-Hives for multi-site organisations
					</li>
				</ul>
			</div>
		</div>
	</section>

	<!-- Technical Edge -->
	<section class="bg-white border-y border-gray-200">
		<div class="max-w-5xl mx-auto px-4 py-16">
			<h2 class="text-2xl font-bold text-gray-900 text-center mb-3">Under the Hood</h2>
			<p class="text-center text-gray-500 mb-12 max-w-2xl mx-auto">
				Built for performance, security, and resilience from the ground up.
			</p>

			<div class="grid grid-cols-1 md:grid-cols-2 gap-10">
				<!-- WebAssembly Sandboxing -->
				<div class="flex gap-4">
					<div class="w-10 h-10 bg-purple-100 rounded-lg flex items-center justify-center shrink-0">
						<svg
							class="w-5 h-5 text-purple-600"
							fill="none"
							stroke="currentColor"
							viewBox="0 0 24 24"
						>
							<path
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"
							/>
						</svg>
					</div>
					<div>
						<h3 class="font-semibold text-gray-900 mb-1">Sandboxed Micro-Apps</h3>
						<p class="text-sm text-gray-600">
							Every AI capability runs in a WebAssembly sandbox with capability-based security. Each
							micro-app gets exactly the data slice and AI tools it needs &mdash; nothing more.
							Memory-isolated, fuel-metered, and auditable.
						</p>
					</div>
				</div>

				<!-- Zenoh P2P -->
				<div class="flex gap-4">
					<div class="w-10 h-10 bg-purple-100 rounded-lg flex items-center justify-center shrink-0">
						<svg
							class="w-5 h-5 text-purple-600"
							fill="none"
							stroke="currentColor"
							viewBox="0 0 24 24"
						>
							<path
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M8 7h12m0 0l-4-4m4 4l-4 4m0 6H4m0 0l4 4m-4-4l4-4"
							/>
						</svg>
					</div>
					<div>
						<h3 class="font-semibold text-gray-900 mb-1">Zenoh Mesh Networking</h3>
						<p class="text-sm text-gray-600">
							Eclipse Zenoh unifies pub/sub, query/reply, and storage in one protocol. Automatic
							peer discovery, intermittent connectivity recovery, and 13-16 microsecond P2P latency.
							Designed for networks that aren't always there.
						</p>
					</div>
				</div>

				<!-- CRDT -->
				<div class="flex gap-4">
					<div class="w-10 h-10 bg-purple-100 rounded-lg flex items-center justify-center shrink-0">
						<svg
							class="w-5 h-5 text-purple-600"
							fill="none"
							stroke="currentColor"
							viewBox="0 0 24 24"
						>
							<path
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"
							/>
						</svg>
					</div>
					<div>
						<h3 class="font-semibold text-gray-900 mb-1">Conflict-Free Data Merge</h3>
						<p class="text-sm text-gray-600">
							Mutable data uses CRDTs (Conflict-free Replicated Data Types) with causal ordering.
							Multiple people edit the same record offline &mdash; changes merge automatically
							without conflicts when peers reconnect.
						</p>
					</div>
				</div>

				<!-- Local AI -->
				<div class="flex gap-4">
					<div class="w-10 h-10 bg-purple-100 rounded-lg flex items-center justify-center shrink-0">
						<svg
							class="w-5 h-5 text-purple-600"
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
						<h3 class="font-semibold text-gray-900 mb-1">Laser-Focused Local AI</h3>
						<p class="text-sm text-gray-600">
							Lightweight ONNX models run on your hardware. Each micro-app uses a model optimised
							for its single task &mdash; semantic search, classification, or extraction. No
							generalist models burning tokens. Small, fast, and precise.
						</p>
					</div>
				</div>
			</div>
		</div>
	</section>

	<!-- Everything in Blanket Bog plus... -->
	<section class="max-w-5xl mx-auto px-4 py-16">
		<h2 class="text-2xl font-bold text-gray-900 text-center mb-3">
			Everything in Blanket Bog, Plus
		</h2>
		<p class="text-center text-gray-500 mb-10 max-w-2xl mx-auto">
			Flower Meadow includes all Blanket Bog features &mdash; interactive tables, local-first speed,
			change notifications, and AI queries &mdash; plus the full P2P micro-app platform.
		</p>

		<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
			<div class="bg-gray-50 rounded-lg p-4 text-center">
				<p class="text-sm font-medium text-gray-900">P2P Data Sync</p>
				<p class="text-xs text-gray-500 mt-1">Hive-Bee architecture</p>
			</div>
			<div class="bg-gray-50 rounded-lg p-4 text-center">
				<p class="text-sm font-medium text-gray-900">AI Micro-Apps</p>
				<p class="text-xs text-gray-500 mt-1">Sandboxed, single-purpose</p>
			</div>
			<div class="bg-gray-50 rounded-lg p-4 text-center">
				<p class="text-sm font-medium text-gray-900">Offline AI</p>
				<p class="text-xs text-gray-500 mt-1">Local ONNX inference</p>
			</div>
			<div class="bg-gray-50 rounded-lg p-4 text-center">
				<p class="text-sm font-medium text-gray-900">Data Sovereignty</p>
				<p class="text-xs text-gray-500 mt-1">Zero cloud or own Hive</p>
			</div>
			<div class="bg-gray-50 rounded-lg p-4 text-center">
				<p class="text-sm font-medium text-gray-900">CRDT Merge</p>
				<p class="text-xs text-gray-500 mt-1">Conflict-free collaboration</p>
			</div>
			<div class="bg-gray-50 rounded-lg p-4 text-center">
				<p class="text-sm font-medium text-gray-900">Audit Trail</p>
				<p class="text-xs text-gray-500 mt-1">Hash-chained, immutable</p>
			</div>
			<div class="bg-gray-50 rounded-lg p-4 text-center">
				<p class="text-sm font-medium text-gray-900">Regulatory Alerts</p>
				<p class="text-xs text-gray-500 mt-1">Legislation change detection</p>
			</div>
			<div class="bg-gray-50 rounded-lg p-4 text-center">
				<p class="text-sm font-medium text-gray-900">Field Tools</p>
				<p class="text-xs text-gray-500 mt-1">On-site compliance queries</p>
			</div>
		</div>
	</section>

	<!-- Why Flower Meadow -->
	<section class="bg-white border-t border-gray-200">
		<div class="max-w-3xl mx-auto px-4 py-16 text-center">
			<h2 class="text-2xl font-bold text-gray-900 mb-4">Why "Flower Meadow"?</h2>
			<p class="text-gray-600 leading-relaxed">
				Wildflower meadows were once common across the UK but are now rare and precious &mdash; 97%
				have been lost since the 1930s. Those that remain are extraordinarily rich ecosystems,
				supporting hundreds of species in a single field. Like a flower meadow, this tier is a rich,
				diverse, and carefully cultivated environment &mdash; many focused capabilities working
				together in one thriving system.
			</p>
		</div>
	</section>

	<!-- CTA -->
	<section style="background-color: #6b21a8;" class="text-white">
		<div class="max-w-3xl mx-auto px-4 py-12 text-center">
			<h2 class="text-2xl font-bold mb-3">Ready for the full platform?</h2>
			<p class="text-purple-200 mb-6">
				Get started with Flower Meadow and bring compliance intelligence directly to your device.
			</p>
			<div class="flex flex-col sm:flex-row gap-4 justify-center">
				{#if $authStore.isAuthenticated}
					<button
						on:click={() => goto('/dashboard')}
						class="px-6 py-3 bg-white text-purple-800 font-semibold rounded-lg hover:bg-purple-50 transition-colors duration-200"
					>
						Go to Dashboard
					</button>
				{:else}
					<a
						href="/register"
						class="px-6 py-3 bg-white text-purple-800 font-semibold rounded-lg hover:bg-purple-50 transition-colors duration-200"
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
			<a href="/blanket-bog" class="text-purple-600 hover:text-purple-700 font-medium"
				>Blanket Bog</a
			>
			<span class="text-gray-300">(Free)</span>
			&middot;
			<a href="/atlantic-rainforest" class="text-purple-600 hover:text-purple-700 font-medium"
				>Atlantic Rainforest</a
			>
			<span class="text-gray-300">(Enterprise)</span>
		</p>
	</section>
</main>
