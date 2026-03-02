<script lang="ts">
	import { onMount } from 'svelte';
	import { goto } from '$app/navigation';
	import { page } from '$app/stores';
	import { authStore } from '$lib/stores/auth';

	let authorized = false;

	onMount(() => {
		if (!$authStore.isAuthenticated) {
			goto('/login');
			return;
		}
		if ($authStore.role !== 'owner' && $authStore.role !== 'admin') {
			goto('/dashboard');
			return;
		}
		authorized = true;
	});

	$: currentPath = $page.url.pathname;

	function navClass(path: string): string {
		const active = currentPath === path || (path !== '/admin' && currentPath.startsWith(path));
		return active
			? 'text-blue-600 border-b-2 border-blue-600 pb-2'
			: 'text-gray-500 hover:text-gray-700 pb-2';
	}
</script>

{#if authorized}
	<main class="min-h-screen bg-gray-50">
		<div class="max-w-5xl mx-auto px-4 py-8">
			<div class="mb-6">
				<a href="/dashboard" class="text-sm text-blue-600 hover:text-blue-500">&larr; Dashboard</a>
			</div>

			<h1 class="text-3xl font-bold text-gray-900 mb-2">Admin</h1>
			<p class="text-gray-600 mb-6">Manage users and organization settings.</p>

			<nav class="flex space-x-6 border-b border-gray-200 mb-8">
				<a href="/admin" class="text-sm font-medium {navClass('/admin')}">Overview</a>
				<a href="/admin/users" class="text-sm font-medium {navClass('/admin/users')}">Users</a>
				<a href="/admin/organization" class="text-sm font-medium {navClass('/admin/organization')}"
					>Organization</a
				>
			</nav>

			<slot />
		</div>
	</main>
{/if}
