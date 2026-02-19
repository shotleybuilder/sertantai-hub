<script lang="ts">
	import { register } from '$lib/stores/auth';
	import { goto } from '$app/navigation';

	let email = '';
	let password = '';
	let confirmPassword = '';
	let error = '';
	let loading = false;

	function validate(): string | null {
		if (!email) return 'Email is required';
		if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) return 'Invalid email format';
		if (!password) return 'Password is required';
		if (password.length < 8) return 'Password must be at least 8 characters';
		if (password !== confirmPassword) return 'Passwords do not match';
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
		const result = await register(email, password);
		loading = false;

		if (result.ok) {
			goto('/');
		} else {
			error = result.error || 'Registration failed';
		}
	}
</script>

<main class="min-h-screen flex items-center justify-center p-8 bg-gray-50">
	<div class="max-w-md w-full space-y-6">
		<div class="text-center">
			<h1 class="text-3xl font-bold text-gray-900">Create Account</h1>
			<p class="mt-2 text-gray-600">Register for SertantAI Hub</p>
		</div>

		<div class="bg-white rounded-lg shadow-lg p-8">
			{#if error}
				<div class="mb-4 p-3 bg-red-50 border border-red-200 rounded-md">
					<p class="text-sm text-red-600">{error}</p>
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
						autocomplete="new-password"
						class="mt-1 block w-full rounded-md border-gray-300 shadow-sm
							focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
						placeholder="At least 8 characters"
					/>
				</div>

				<div>
					<label for="confirmPassword" class="block text-sm font-medium text-gray-700"
						>Confirm Password</label
					>
					<input
						id="confirmPassword"
						type="password"
						bind:value={confirmPassword}
						autocomplete="new-password"
						class="mt-1 block w-full rounded-md border-gray-300 shadow-sm
							focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
						placeholder="Confirm your password"
					/>
				</div>

				<button
					type="submit"
					disabled={loading}
					class="w-full px-4 py-2 bg-blue-600 text-white font-medium rounded-lg
						hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
						disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors duration-200"
				>
					{loading ? 'Creating account...' : 'Create Account'}
				</button>
			</form>
		</div>

		<p class="text-center text-sm text-gray-600">
			Already have an account?
			<a href="/login" class="font-medium text-blue-600 hover:text-blue-500">Sign in</a>
		</p>
	</div>
</main>
