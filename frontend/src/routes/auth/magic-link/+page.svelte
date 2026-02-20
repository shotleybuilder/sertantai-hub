<script lang="ts">
	import { onMount } from 'svelte';
	import { goto } from '$app/navigation';
	import { page } from '$app/stores';
	import { completeMagicLink } from '$lib/stores/auth';

	let status: 'verifying' | 'success' | 'error' = 'verifying';
	let error = '';

	onMount(async () => {
		const token = $page.url.searchParams.get('token');

		if (!token) {
			status = 'error';
			error = 'No token found in the link. Please request a new magic link.';
			return;
		}

		const result = await completeMagicLink(token);

		if (result.ok) {
			status = 'success';
			setTimeout(() => goto('/dashboard'), 1500);
		} else {
			status = 'error';
			error = result.error || 'Authentication failed';
		}
	});
</script>

<main class="min-h-screen flex items-center justify-center p-8 bg-gray-50">
	<div class="max-w-md w-full space-y-6">
		<div class="text-center">
			<h1 class="text-3xl font-bold text-gray-900">Magic Link</h1>
		</div>

		<div class="bg-white rounded-lg shadow-lg p-8 text-center">
			{#if status === 'verifying'}
				<div class="space-y-4">
					<div class="animate-spin rounded-full h-10 w-10 border-b-2 border-blue-600 mx-auto"></div>
					<p class="text-gray-600">Verifying your magic link...</p>
				</div>
			{:else if status === 'success'}
				<div class="space-y-4">
					<div class="text-green-500 text-4xl">&#10003;</div>
					<p class="text-gray-900 font-medium">You're signed in!</p>
					<p class="text-sm text-gray-500">Redirecting to dashboard...</p>
				</div>
			{:else}
				<div class="space-y-4">
					<div class="text-red-500 text-4xl">&#10007;</div>
					<p class="text-red-600">{error}</p>
					<div class="pt-4 space-y-2">
						<a
							href="/login"
							class="block w-full px-4 py-2 bg-blue-600 text-white font-medium rounded-lg
								hover:bg-blue-700 transition-colors duration-200 text-center"
						>
							Back to Sign In
						</a>
					</div>
				</div>
			{/if}
		</div>
	</div>
</main>
