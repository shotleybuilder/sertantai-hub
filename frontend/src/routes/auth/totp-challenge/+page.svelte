<script lang="ts">
	import { onMount } from 'svelte';
	import { goto } from '$app/navigation';
	import { page } from '$app/stores';
	import { completeTotpChallenge, completeTotpRecovery } from '$lib/stores/auth';

	let sessionToken = '';
	let email = '';
	let code = '';
	let backupCode = '';
	let error = '';
	let loading = false;
	let mode: 'totp' | 'backup' = 'totp';
	let backupCodesRemaining: number | null = null;

	onMount(() => {
		sessionToken = $page.url.searchParams.get('session_token') || '';
		email = $page.url.searchParams.get('email') || '';

		if (!sessionToken) {
			goto('/login');
		}
	});

	async function handleTotpSubmit() {
		if (code.length !== 6) {
			error = 'Please enter a 6-digit code';
			return;
		}
		loading = true;
		error = '';
		const result = await completeTotpChallenge(sessionToken, code);
		loading = false;

		if (result.ok) {
			goto('/dashboard');
		} else {
			error = result.error || 'Invalid code';
			code = '';
		}
	}

	async function handleBackupSubmit() {
		if (!backupCode.trim()) {
			error = 'Please enter a backup code';
			return;
		}
		loading = true;
		error = '';
		const result = await completeTotpRecovery(sessionToken, backupCode.trim());
		loading = false;

		if (result.ok) {
			if (result.backupCodesRemaining !== undefined) {
				backupCodesRemaining = result.backupCodesRemaining;
			}
			goto('/dashboard');
		} else {
			error = result.error || 'Invalid backup code';
			backupCode = '';
		}
	}

	function switchMode(newMode: 'totp' | 'backup') {
		mode = newMode;
		error = '';
		code = '';
		backupCode = '';
	}
</script>

<main class="min-h-screen flex items-center justify-center p-8 bg-gray-50">
	<div class="max-w-md w-full space-y-6">
		<div class="text-center">
			<h1 class="text-3xl font-bold text-gray-900">Two-Factor Authentication</h1>
			{#if email}
				<p class="mt-2 text-gray-600">Enter the code for {email}</p>
			{/if}
		</div>

		<div class="bg-white rounded-lg shadow-lg p-8">
			{#if error}
				<div class="mb-4 p-3 bg-red-50 border border-red-200 rounded-md">
					<p class="text-sm text-red-600">{error}</p>
				</div>
			{/if}

			{#if mode === 'totp'}
				<div class="space-y-4">
					<p class="text-sm text-gray-600">Enter the 6-digit code from your authenticator app.</p>

					<div>
						<input
							type="text"
							inputmode="numeric"
							pattern="[0-9]*"
							maxlength="6"
							bind:value={code}
							placeholder="000000"
							autofocus
							class="block w-full rounded-md border-gray-300 shadow-sm
								focus:border-blue-500 focus:ring-blue-500 font-mono text-center text-2xl tracking-[0.5em] py-3"
						/>
					</div>

					<button
						on:click={handleTotpSubmit}
						disabled={loading || code.length !== 6}
						class="w-full px-4 py-2 bg-blue-600 text-white font-medium rounded-lg
							hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
							disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors duration-200"
					>
						{loading ? 'Verifying...' : 'Verify'}
					</button>

					<button
						on:click={() => switchMode('backup')}
						class="w-full text-sm text-gray-500 hover:text-gray-700 transition-colors duration-200"
					>
						Lost your authenticator? Use a backup code
					</button>
				</div>
			{:else}
				<div class="space-y-4">
					<p class="text-sm text-gray-600">
						Enter one of your backup codes. Each code can only be used once.
					</p>

					<div>
						<input
							type="text"
							maxlength="8"
							bind:value={backupCode}
							placeholder="ABCD1234"
							autofocus
							class="block w-full rounded-md border-gray-300 shadow-sm
								focus:border-blue-500 focus:ring-blue-500 font-mono text-center text-lg tracking-widest py-3 uppercase"
						/>
					</div>

					<button
						on:click={handleBackupSubmit}
						disabled={loading || !backupCode.trim()}
						class="w-full px-4 py-2 bg-blue-600 text-white font-medium rounded-lg
							hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
							disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors duration-200"
					>
						{loading ? 'Verifying...' : 'Verify Backup Code'}
					</button>

					<button
						on:click={() => switchMode('totp')}
						class="w-full text-sm text-gray-500 hover:text-gray-700 transition-colors duration-200"
					>
						Use authenticator app instead
					</button>
				</div>
			{/if}
		</div>

		<p class="text-center text-sm text-gray-600">
			<a href="/login" class="font-medium text-blue-600 hover:text-blue-500">Back to Sign In</a>
		</p>
	</div>
</main>
