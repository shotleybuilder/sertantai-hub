<script lang="ts">
	import { onMount } from 'svelte';
	import QRCode from 'qrcode';
	import { totpStatus, totpSetup, totpEnable, totpDisable } from '$lib/api/totp';
	import type { TotpSetupResponse } from '$lib/api/totp';

	type Step = 'loading' | 'status' | 'setup' | 'disable';

	let step: Step = 'loading';
	let totpEnabled = false;
	let loading = false;
	let error = '';
	let success = '';

	// Setup state
	let setupData: TotpSetupResponse | null = null;
	let qrDataUrl = '';
	let verifyCode = '';
	let backupCodesCopied = false;

	// Disable state
	let disableCode = '';

	onMount(async () => {
		const result = await totpStatus();
		if (result.ok && result.data) {
			totpEnabled = result.data.enabled;
		}
		step = 'status';
	});

	async function handleSetup() {
		loading = true;
		error = '';
		success = '';
		const result = await totpSetup();
		loading = false;

		if (result.ok && result.data) {
			setupData = result.data;
			qrDataUrl = await QRCode.toDataURL(result.data.uri, { width: 256, margin: 2 });
			step = 'setup';
		} else {
			error = result.error || 'Failed to start TOTP setup';
		}
	}

	async function handleVerify() {
		if (verifyCode.length !== 6) {
			error = 'Please enter a 6-digit code';
			return;
		}
		loading = true;
		error = '';
		const result = await totpEnable(verifyCode);
		loading = false;

		if (result.ok) {
			totpEnabled = true;
			success = 'Two-factor authentication has been enabled.';
			step = 'status';
			setupData = null;
			qrDataUrl = '';
			verifyCode = '';
		} else {
			error = result.error || 'Invalid verification code';
		}
	}

	async function handleDisable() {
		if (disableCode.length !== 6) {
			error = 'Please enter a 6-digit code';
			return;
		}
		loading = true;
		error = '';
		const result = await totpDisable(disableCode);
		loading = false;

		if (result.ok) {
			totpEnabled = false;
			success = 'Two-factor authentication has been disabled.';
			step = 'status';
			disableCode = '';
		} else {
			error = result.error || 'Invalid code';
		}
	}

	function copyBackupCodes() {
		if (setupData?.backup_codes) {
			navigator.clipboard.writeText(setupData.backup_codes.join('\n'));
			backupCodesCopied = true;
			setTimeout(() => (backupCodesCopied = false), 2000);
		}
	}

	function cancelSetup() {
		step = 'status';
		setupData = null;
		qrDataUrl = '';
		verifyCode = '';
		error = '';
	}

	function cancelDisable() {
		step = 'status';
		disableCode = '';
		error = '';
	}
</script>

<main class="min-h-screen bg-gray-50">
	<div class="max-w-lg mx-auto px-4 py-12">
		<div class="mb-6">
			<a href="/dashboard" class="text-sm text-blue-600 hover:text-blue-500">&larr; Dashboard</a>
		</div>

		<h1 class="text-3xl font-bold text-gray-900 mb-2">Security Settings</h1>
		<p class="text-gray-600 mb-8">Manage two-factor authentication for your account.</p>

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
		{#if step === 'loading'}
			<div class="bg-white rounded-lg shadow-lg p-8 text-center">
				<div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600 mx-auto"></div>
				<p class="text-gray-500 mt-4">Loading security settings...</p>
			</div>

			<!-- Status View -->
		{:else if step === 'status'}
			<div class="bg-white rounded-lg shadow-lg p-8">
				<div class="flex items-center justify-between">
					<div class="flex items-center gap-3">
						<svg
							class="w-8 h-8 text-gray-400"
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
						<div>
							<h2 class="text-lg font-semibold text-gray-900">Two-Factor Authentication</h2>
							{#if totpEnabled}
								<span
									class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-green-100 text-green-800"
								>
									Enabled
								</span>
							{:else}
								<span
									class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-gray-100 text-gray-600"
								>
									Disabled
								</span>
							{/if}
						</div>
					</div>
				</div>

				<p class="mt-4 text-sm text-gray-600">
					{#if totpEnabled}
						Your account is protected with an authenticator app. You'll need to enter a code from
						your app when signing in.
					{:else}
						Add an extra layer of security to your account by requiring a code from an authenticator
						app when signing in.
					{/if}
				</p>

				<div class="mt-6">
					{#if totpEnabled}
						<button
							on:click={() => {
								step = 'disable';
								error = '';
								success = '';
							}}
							class="px-4 py-2 text-red-600 font-medium rounded-lg border border-red-300
								hover:bg-red-50 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2
								transition-colors duration-200"
						>
							Disable 2FA
						</button>
					{:else}
						<button
							on:click={handleSetup}
							disabled={loading}
							class="px-4 py-2 bg-blue-600 text-white font-medium rounded-lg
								hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
								disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors duration-200"
						>
							{loading ? 'Setting up...' : 'Enable 2FA'}
						</button>
					{/if}
				</div>
			</div>

			<!-- Setup Wizard -->
		{:else if step === 'setup' && setupData}
			<div class="bg-white rounded-lg shadow-lg p-8 space-y-6">
				<h2 class="text-lg font-semibold text-gray-900">Set Up Two-Factor Authentication</h2>

				<!-- Step 1: QR Code -->
				<div>
					<h3 class="text-sm font-medium text-gray-700 mb-2">1. Scan QR Code</h3>
					<p class="text-sm text-gray-500 mb-3">
						Scan this QR code with your authenticator app (Google Authenticator, Authy, 1Password,
						etc.)
					</p>
					<div class="flex justify-center p-4 bg-white border border-gray-200 rounded-lg">
						<img src={qrDataUrl} alt="TOTP QR Code" class="w-64 h-64" />
					</div>
				</div>

				<!-- Manual Entry -->
				<div>
					<p class="text-sm text-gray-500 mb-1">Can't scan? Enter this code manually:</p>
					<div class="flex items-center gap-2">
						<code
							class="flex-1 block px-3 py-2 bg-gray-50 border border-gray-200 rounded-md font-mono text-sm text-gray-800 select-all"
						>
							{setupData.secret}
						</code>
					</div>
				</div>

				<!-- Step 2: Backup Codes -->
				<div>
					<h3 class="text-sm font-medium text-gray-700 mb-2">2. Save Backup Codes</h3>
					<div class="p-4 bg-amber-50 border border-amber-200 rounded-lg">
						<p class="text-sm text-amber-800 font-medium mb-3">
							Save these codes somewhere safe. Each code can only be used once. They will not be
							shown again.
						</p>
						<div class="grid grid-cols-2 gap-1 mb-3">
							{#each setupData.backup_codes as code}
								<code
									class="px-2 py-1 text-sm font-mono text-gray-800 bg-white rounded border border-amber-200"
								>
									{code}
								</code>
							{/each}
						</div>
						<button
							on:click={copyBackupCodes}
							class="text-sm text-amber-700 hover:text-amber-900 font-medium transition-colors duration-200"
						>
							{backupCodesCopied ? 'Copied!' : 'Copy all codes'}
						</button>
					</div>
				</div>

				<!-- Step 3: Verify -->
				<div>
					<h3 class="text-sm font-medium text-gray-700 mb-2">3. Verify Setup</h3>
					<p class="text-sm text-gray-500 mb-3">
						Enter the 6-digit code from your authenticator app to complete setup.
					</p>
					<div class="flex gap-3">
						<input
							type="text"
							inputmode="numeric"
							pattern="[0-9]*"
							maxlength="6"
							bind:value={verifyCode}
							placeholder="000000"
							class="flex-1 rounded-md border-gray-300 shadow-sm
								focus:border-blue-500 focus:ring-blue-500 sm:text-sm font-mono text-center text-lg tracking-widest"
						/>
						<button
							on:click={handleVerify}
							disabled={loading || verifyCode.length !== 6}
							class="px-4 py-2 bg-blue-600 text-white font-medium rounded-lg
								hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
								disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors duration-200"
						>
							{loading ? 'Verifying...' : 'Verify & Enable'}
						</button>
					</div>
				</div>

				<div class="pt-2 border-t border-gray-200">
					<button
						on:click={cancelSetup}
						class="text-sm text-gray-500 hover:text-gray-700 transition-colors duration-200"
					>
						Cancel setup
					</button>
				</div>
			</div>

			<!-- Disable View -->
		{:else if step === 'disable'}
			<div class="bg-white rounded-lg shadow-lg p-8 space-y-4">
				<h2 class="text-lg font-semibold text-gray-900">Disable Two-Factor Authentication</h2>
				<p class="text-sm text-gray-600">
					Enter a code from your authenticator app to confirm disabling 2FA. Your account will be
					less secure.
				</p>

				<div class="flex gap-3">
					<input
						type="text"
						inputmode="numeric"
						pattern="[0-9]*"
						maxlength="6"
						bind:value={disableCode}
						placeholder="000000"
						class="flex-1 rounded-md border-gray-300 shadow-sm
							focus:border-blue-500 focus:ring-blue-500 sm:text-sm font-mono text-center text-lg tracking-widest"
					/>
					<button
						on:click={handleDisable}
						disabled={loading || disableCode.length !== 6}
						class="px-4 py-2 text-white font-medium rounded-lg bg-red-600
							hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2
							disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors duration-200"
					>
						{loading ? 'Disabling...' : 'Disable 2FA'}
					</button>
				</div>

				<button
					on:click={cancelDisable}
					class="text-sm text-gray-500 hover:text-gray-700 transition-colors duration-200"
				>
					Cancel
				</button>
			</div>
		{/if}
	</div>
</main>
