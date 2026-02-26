<script lang="ts">
	import { onMount } from 'svelte';
	import type { Subscription, CreateSubscriptionParams } from '$lib/types/notifications';
	import {
		listSubscriptions,
		createSubscription,
		updateSubscription,
		deleteSubscription,
		listEvents
	} from '$lib/api/subscriptions';
	import type { LawChangeEvent } from '$lib/types/notifications';
	import SubscriptionCard from '$lib/components/SubscriptionCard.svelte';
	import SubscriptionForm from '$lib/components/SubscriptionForm.svelte';

	const MAX_FREE_SUBS = 3;

	type View = 'loading' | 'list' | 'create' | 'edit';

	let view: View = 'loading';
	let subscriptions: Subscription[] = [];
	let events: LawChangeEvent[] = [];
	let editingSubscription: Subscription | null = null;
	let loading = false;
	let error = '';
	let success = '';

	onMount(async () => {
		await loadData();
		view = 'list';
	});

	async function loadData() {
		const [subsResult, eventsResult] = await Promise.all([listSubscriptions(), listEvents()]);

		if (subsResult.ok && subsResult.data) {
			subscriptions = subsResult.data;
		}
		if (eventsResult.ok && eventsResult.data) {
			events = eventsResult.data.slice(0, 10);
		}
	}

	async function handleCreate(e: CustomEvent<CreateSubscriptionParams>) {
		loading = true;
		error = '';
		const result = await createSubscription(e.detail);
		loading = false;

		if (result.ok) {
			success = 'Subscription created.';
			await loadData();
			view = 'list';
		} else {
			error = result.error || 'Failed to create subscription';
		}
	}

	async function handleUpdate(e: CustomEvent<CreateSubscriptionParams>) {
		if (!editingSubscription) return;
		loading = true;
		error = '';
		const result = await updateSubscription(editingSubscription.id, e.detail);
		loading = false;

		if (result.ok) {
			success = 'Subscription updated.';
			editingSubscription = null;
			await loadData();
			view = 'list';
		} else {
			error = result.error || 'Failed to update subscription';
		}
	}

	async function handleDelete(e: CustomEvent<Subscription>) {
		if (!confirm(`Delete "${e.detail.name}"?`)) return;
		error = '';
		const result = await deleteSubscription(e.detail.id);

		if (result.ok) {
			success = 'Subscription deleted.';
			await loadData();
		} else {
			error = result.error || 'Failed to delete subscription';
		}
	}

	async function handleToggle(e: CustomEvent<Subscription>) {
		error = '';
		const result = await updateSubscription(e.detail.id, { enabled: !e.detail.enabled });

		if (result.ok) {
			await loadData();
		} else {
			error = result.error || 'Failed to toggle subscription';
		}
	}

	function handleEdit(e: CustomEvent<Subscription>) {
		editingSubscription = e.detail;
		error = '';
		success = '';
		view = 'edit';
	}

	function formatDate(dateStr: string): string {
		return new Date(dateStr).toLocaleDateString('en-GB', {
			day: 'numeric',
			month: 'short',
			year: 'numeric',
			hour: '2-digit',
			minute: '2-digit'
		});
	}
</script>

<main class="min-h-screen bg-gray-50">
	<div class="max-w-2xl mx-auto px-4 py-12">
		<div class="mb-6">
			<a href="/dashboard" class="text-sm text-blue-600 hover:text-blue-500">&larr; Dashboard</a>
		</div>

		<h1 class="text-3xl font-bold text-gray-900 mb-2">Notification Subscriptions</h1>
		<p class="text-gray-600 mb-8">
			Subscribe to UK law changes that match your interests. You'll receive email notifications when
			matching changes are detected.
		</p>

		{#if error}
			<div class="mb-4 p-3 bg-red-50 border border-red-200 rounded-md">
				<p class="text-sm text-red-600">{error}</p>
			</div>
		{/if}

		{#if success}
			<div class="mb-4 p-3 bg-green-50 border border-green-200 rounded-md">
				<p class="text-sm text-green-700">{success}</p>
			</div>
		{/if}

		<!-- Loading -->
		{#if view === 'loading'}
			<div class="bg-white rounded-lg shadow-lg p-8 text-center">
				<div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
				<p class="text-gray-500 mt-4">Loading subscriptions...</p>
			</div>

			<!-- List View -->
		{:else if view === 'list'}
			<div class="mb-6 flex items-center justify-between">
				<p class="text-sm text-gray-500">
					{subscriptions.length} of {MAX_FREE_SUBS} subscriptions
				</p>
				<button
					on:click={() => {
						view = 'create';
						error = '';
						success = '';
					}}
					disabled={subscriptions.length >= MAX_FREE_SUBS}
					class="px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-lg
						hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
						disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors duration-200"
				>
					{subscriptions.length >= MAX_FREE_SUBS ? 'Limit Reached' : 'Add Subscription'}
				</button>
			</div>

			{#if subscriptions.length === 0}
				<div class="bg-white rounded-lg shadow-lg p-8 text-center">
					<svg
						class="w-12 h-12 text-gray-300 mx-auto mb-4"
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
					<p class="text-gray-500">No subscriptions yet.</p>
					<p class="text-sm text-gray-400 mt-1">
						Create your first subscription to start receiving law change notifications.
					</p>
				</div>
			{:else}
				<div class="space-y-3">
					{#each subscriptions as subscription (subscription.id)}
						<SubscriptionCard
							{subscription}
							on:edit={handleEdit}
							on:delete={handleDelete}
							on:toggle={handleToggle}
						/>
					{/each}
				</div>
			{/if}

			<!-- Recent Events -->
			{#if events.length > 0}
				<div class="mt-10">
					<h2 class="text-lg font-semibold text-gray-900 mb-4">Recent Matches</h2>
					<div class="bg-white rounded-lg shadow divide-y divide-gray-100">
						{#each events as event (event.id)}
							<div class="p-4">
								<div class="flex items-start justify-between">
									<div>
										<p class="text-sm font-medium text-gray-900">{event.law_title}</p>
										<p class="text-xs text-gray-500 mt-0.5">
											<span
												class="inline-flex items-center px-1.5 py-0.5 rounded text-xs font-medium bg-gray-100 text-gray-600"
											>
												{event.change_type}
											</span>
											<span class="ml-2">{event.law_name}</span>
										</p>
									</div>
									<span class="text-xs text-gray-400 shrink-0 ml-4">
										{formatDate(event.inserted_at)}
									</span>
								</div>
								{#if event.summary}
									<p class="text-xs text-gray-500 mt-1">{event.summary}</p>
								{/if}
							</div>
						{/each}
					</div>
				</div>
			{/if}

			<!-- Create Form -->
		{:else if view === 'create'}
			<div class="bg-white rounded-lg shadow-lg p-8">
				<h2 class="text-lg font-semibold text-gray-900 mb-6">New Subscription</h2>
				<SubscriptionForm {loading} on:submit={handleCreate} on:cancel={() => (view = 'list')} />
			</div>

			<!-- Edit Form -->
		{:else if view === 'edit' && editingSubscription}
			<div class="bg-white rounded-lg shadow-lg p-8">
				<h2 class="text-lg font-semibold text-gray-900 mb-6">Edit Subscription</h2>
				<SubscriptionForm
					subscription={editingSubscription}
					{loading}
					on:submit={handleUpdate}
					on:cancel={() => {
						editingSubscription = null;
						view = 'list';
					}}
				/>
			</div>
		{/if}
	</div>
</main>
