<script lang="ts">
	import '../app.css';
	import { onMount } from 'svelte';
	import { page } from '$app/stores';
	import { goto } from '$app/navigation';
	import { QueryClientProvider } from '@tanstack/svelte-query';
	import { queryClient } from '$lib/query/client';
	import { authStore, initialize } from '$lib/stores/auth';
	import NavBar from '$lib/components/NavBar.svelte';

	const publicPaths = ['/', '/login', '/register'];
	let ready = false;

	onMount(async () => {
		await initialize();
		ready = true;
	});

	$: if (ready && !$authStore.isAuthenticated && !publicPaths.includes($page.url.pathname)) {
		goto('/login');
	}
</script>

{#if ready}
	<NavBar />
	{#if queryClient}
		<QueryClientProvider client={queryClient}>
			<slot />
		</QueryClientProvider>
	{:else}
		<slot />
	{/if}
{/if}
