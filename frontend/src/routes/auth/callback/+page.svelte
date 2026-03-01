<script lang="ts">
	import { onMount } from 'svelte';
	import { goto } from '$app/navigation';
	import { page } from '$app/stores';
	import { initialize } from '$lib/stores/auth';

	let status: 'verifying' | 'success' | 'error' = 'verifying';
	let error = '';

	onMount(async () => {
		const token = $page.url.searchParams.get('token');
		const errorParam = $page.url.searchParams.get('error');

		if (errorParam) {
			status = 'error';
			error = formatError(errorParam);
			return;
		}

		if (!token) {
			status = 'error';
			error = 'No authentication token received. Please try signing in again.';
			return;
		}

		// Store token and initialize auth state from JWT claims
		localStorage.setItem('sertantai_token', token);
		await initialize();

		status = 'success';
		setTimeout(() => goto('/dashboard'), 1500);
	});

	function formatError(code: string): string {
		switch (code) {
			case 'account_deactivated':
				return 'Your account has been deactivated. Please contact support.';
			case 'oauth_failed':
				return 'GitHub authentication failed. Please try again.';
			case 'access_denied':
				return 'Access was denied. Please try again or use a different sign-in method.';
			default:
				return 'Authentication failed. Please try again.';
		}
	}
</script>

<main class="min-h-screen flex items-center justify-center p-8 bg-gray-50">
	<div class="max-w-md w-full space-y-6">
		<div class="text-center">
			<h1 class="text-3xl font-bold text-gray-900">GitHub Sign In</h1>
		</div>

		<div class="bg-white rounded-lg shadow-lg p-8 text-center">
			{#if status === 'verifying'}
				<div class="space-y-4">
					<div class="animate-spin rounded-full h-10 w-10 border-b-2 border-blue-600 mx-auto"></div>
					<p class="text-gray-600">Completing sign in...</p>
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
