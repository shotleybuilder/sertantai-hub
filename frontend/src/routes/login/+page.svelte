<script lang="ts">
	import { login, requestMagicLink } from '$lib/stores/auth';
	import { goto } from '$app/navigation';

	const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:4006';

	let email = '';
	let password = '';
	let error = '';
	let loading = false;
	let magicLinkSent = false;
	let magicLinkLoading = false;

	function validate(): string | null {
		if (!email) return 'Email is required';
		if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) return 'Invalid email format';
		if (!password) return 'Password is required';
		if (password.length < 8) return 'Password must be at least 8 characters';
		return null;
	}

	function validateEmail(): string | null {
		if (!email) return 'Email is required';
		if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) return 'Invalid email format';
		return null;
	}

	async function handleSubmit() {
		error = '';
		const validationError = validate();
		if (validationError) {
			error = validationError;
			return;
		}

		loading = true;
		const result = await login(email, password);
		loading = false;

		if (result.ok) {
			goto('/dashboard');
		} else if (result.totpRequired && result.sessionToken) {
			const params = new URLSearchParams({
				session_token: result.sessionToken,
				email: result.email || email
			});
			goto(`/auth/totp-challenge?${params.toString()}`);
		} else {
			error = result.error || 'Login failed';
		}
	}

	async function handleMagicLink() {
		error = '';
		magicLinkSent = false;
		const validationError = validateEmail();
		if (validationError) {
			error = validationError;
			return;
		}

		magicLinkLoading = true;
		const result = await requestMagicLink(email);
		magicLinkLoading = false;

		if (result.ok) {
			magicLinkSent = true;
		} else {
			error = result.error || 'Failed to send magic link';
		}
	}
</script>

<main class="min-h-screen flex items-center justify-center p-8 bg-gray-50">
	<div class="max-w-md w-full space-y-6">
		<div class="text-center">
			<h1 class="text-3xl font-bold text-gray-900">Sign In</h1>
			<p class="mt-2 text-gray-600">Sign in to SertantAI Hub</p>
		</div>

		<div class="bg-white rounded-lg shadow-lg p-8">
			{#if error}
				<div class="mb-4 p-3 bg-red-50 border border-red-200 rounded-md">
					<p class="text-sm text-red-600">{error}</p>
				</div>
			{/if}

			{#if magicLinkSent}
				<div class="mb-4 p-3 bg-green-50 border border-green-200 rounded-md">
					<p class="text-sm text-green-700">
						Check your email for a magic link to sign in. The link expires in 15 minutes.
					</p>
				</div>
			{/if}

			<form on:submit|preventDefault={handleSubmit} class="space-y-4">
				<div>
					<label for="email" class="block text-sm font-medium text-gray-700">Email</label>
					<input
						id="email"
						type="email"
						bind:value={email}
						autocomplete="email"
						class="mt-1 block w-full rounded-md border-gray-300 shadow-sm
							focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
						placeholder="you@example.com"
					/>
				</div>

				<div>
					<label for="password" class="block text-sm font-medium text-gray-700">Password</label>
					<input
						id="password"
						type="password"
						bind:value={password}
						autocomplete="current-password"
						class="mt-1 block w-full rounded-md border-gray-300 shadow-sm
							focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
						placeholder="Enter your password"
					/>
				</div>

				<button
					type="submit"
					disabled={loading}
					class="w-full px-4 py-2 bg-blue-600 text-white font-medium rounded-lg
						hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
						disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors duration-200"
				>
					{loading ? 'Signing in...' : 'Sign In'}
				</button>
			</form>

			<div class="relative my-4">
				<div class="absolute inset-0 flex items-center">
					<div class="w-full border-t border-gray-300"></div>
				</div>
				<div class="relative flex justify-center text-sm">
					<span class="bg-white px-2 text-gray-500">or</span>
				</div>
			</div>

			<button
				on:click={handleMagicLink}
				disabled={magicLinkLoading}
				class="w-full px-4 py-2 bg-white text-gray-700 font-medium rounded-lg border border-gray-300
					hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
					disabled:bg-gray-100 disabled:cursor-not-allowed transition-colors duration-200"
			>
				{magicLinkLoading ? 'Sending...' : 'Send Magic Link'}
			</button>

			<a
				href="{API_URL}/api/auth/github"
				class="w-full mt-3 px-4 py-2 bg-gray-900 text-white font-medium rounded-lg
					hover:bg-gray-800 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2
					transition-colors duration-200 flex items-center justify-center gap-2"
			>
				<svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
					<path
						fill-rule="evenodd"
						d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"
						clip-rule="evenodd"
					/>
				</svg>
				Sign in with GitHub
			</a>
		</div>

		<p class="text-center text-sm text-gray-600">
			Don't have an account?
			<a href="/register" class="font-medium text-blue-600 hover:text-blue-500">Register</a>
		</p>
	</div>
</main>
