<script lang="ts">
	import { onMount } from 'svelte';
	import { authStore } from '$lib/stores/auth';
	import { getProfile, updateProfile, changePassword } from '$lib/api/profile';
	import type { ProfileUser } from '$lib/api/profile';

	type View = 'loading' | 'profile' | 'edit' | 'password';

	let view: View = 'loading';
	let profile: ProfileUser | null = null;
	let loading = false;
	let error = '';
	let success = '';

	// Edit state
	let editName = '';
	let editEmail = '';

	// Password state
	let currentPassword = '';
	let newPassword = '';
	let confirmPassword = '';

	onMount(async () => {
		const result = await getProfile();
		if (result.ok && result.data) {
			profile = result.data;
		} else {
			error = result.error || 'Failed to load profile';
		}
		view = 'profile';
	});

	function startEdit() {
		if (!profile) return;
		editName = profile.name || '';
		editEmail = profile.email;
		error = '';
		success = '';
		view = 'edit';
	}

	function startPasswordChange() {
		currentPassword = '';
		newPassword = '';
		confirmPassword = '';
		error = '';
		success = '';
		view = 'password';
	}

	async function handleSaveProfile() {
		if (!profile) return;
		loading = true;
		error = '';

		const params: { name?: string; email?: string } = {};
		if (editName !== (profile.name || '')) params.name = editName;
		if (editEmail !== profile.email) params.email = editEmail;

		if (Object.keys(params).length === 0) {
			view = 'profile';
			loading = false;
			return;
		}

		const result = await updateProfile(params);
		loading = false;

		if (result.ok && result.data) {
			profile = result.data;
			// Update auth store with new info
			authStore.update((state) => ({
				...state,
				user: state.user
					? { ...state.user, email: result.data!.email, name: result.data!.name }
					: null
			}));
			success = 'Profile updated successfully.';
			view = 'profile';
		} else {
			error = result.error || 'Failed to update profile';
		}
	}

	async function handleChangePassword() {
		if (newPassword !== confirmPassword) {
			error = 'New passwords do not match';
			return;
		}
		if (newPassword.length < 8) {
			error = 'New password must be at least 8 characters';
			return;
		}

		loading = true;
		error = '';
		const result = await changePassword(currentPassword, newPassword);
		loading = false;

		if (result.ok) {
			success = 'Password changed successfully.';
			view = 'profile';
		} else {
			error = result.error || 'Failed to change password';
		}
	}

	function cancel() {
		error = '';
		view = 'profile';
	}
</script>

<main class="min-h-screen bg-gray-50">
	<div class="max-w-lg mx-auto px-4 py-12">
		<div class="mb-6">
			<a href="/dashboard" class="text-sm text-blue-600 hover:text-blue-500">&larr; Dashboard</a>
		</div>

		<h1 class="text-3xl font-bold text-gray-900 mb-2">Profile Settings</h1>
		<p class="text-gray-600 mb-8">Manage your name, email address, and password.</p>

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
				<p class="text-gray-500 mt-4">Loading profile...</p>
			</div>

			<!-- Profile View -->
		{:else if view === 'profile'}
			<div class="bg-white rounded-lg shadow-lg p-8 space-y-6">
				<div>
					<h2 class="text-lg font-semibold text-gray-900 mb-4">Profile Information</h2>
					<dl class="space-y-3">
						<div class="flex justify-between">
							<dt class="text-sm text-gray-500">Name</dt>
							<dd class="text-sm font-medium text-gray-900">
								{profile?.name || '—'}
							</dd>
						</div>
						<div class="flex justify-between">
							<dt class="text-sm text-gray-500">Email</dt>
							<dd class="text-sm font-medium text-gray-900">
								{profile?.email || $authStore.user?.email}
							</dd>
						</div>
						<div class="flex justify-between">
							<dt class="text-sm text-gray-500">Role</dt>
							<dd>
								<span
									class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-100 text-blue-800"
								>
									{profile?.role || $authStore.role}
								</span>
							</dd>
						</div>
					</dl>
				</div>

				<div class="flex gap-3 pt-2 border-t border-gray-200">
					<button
						on:click={startEdit}
						class="px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-lg
							hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
							transition-colors duration-200"
					>
						Edit Profile
					</button>
					<button
						on:click={startPasswordChange}
						class="px-4 py-2 text-gray-700 text-sm font-medium rounded-lg border border-gray-300
							hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
							transition-colors duration-200"
					>
						Change Password
					</button>
				</div>
			</div>

			<!-- Edit Profile Form -->
		{:else if view === 'edit'}
			<div class="bg-white rounded-lg shadow-lg p-8 space-y-6">
				<h2 class="text-lg font-semibold text-gray-900">Edit Profile</h2>

				<div>
					<label for="name" class="block text-sm font-medium text-gray-700 mb-1">Name</label>
					<input
						id="name"
						type="text"
						bind:value={editName}
						placeholder="Your name"
						class="w-full rounded-md border-gray-300 shadow-sm
							focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
					/>
				</div>

				<div>
					<label for="email" class="block text-sm font-medium text-gray-700 mb-1">Email</label>
					<input
						id="email"
						type="email"
						bind:value={editEmail}
						class="w-full rounded-md border-gray-300 shadow-sm
							focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
					/>
					<p class="mt-1 text-xs text-gray-400">Changing your email may require re-confirmation.</p>
				</div>

				<div class="flex gap-3">
					<button
						on:click={handleSaveProfile}
						disabled={loading}
						class="px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-lg
							hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
							disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors duration-200"
					>
						{loading ? 'Saving...' : 'Save Changes'}
					</button>
					<button
						on:click={cancel}
						class="px-4 py-2 text-gray-600 text-sm font-medium rounded-lg
							hover:bg-gray-100 transition-colors duration-200"
					>
						Cancel
					</button>
				</div>
			</div>

			<!-- Change Password Form -->
		{:else if view === 'password'}
			<div class="bg-white rounded-lg shadow-lg p-8 space-y-6">
				<h2 class="text-lg font-semibold text-gray-900">Change Password</h2>

				<div>
					<label for="current-password" class="block text-sm font-medium text-gray-700 mb-1">
						Current Password
					</label>
					<input
						id="current-password"
						type="password"
						bind:value={currentPassword}
						class="w-full rounded-md border-gray-300 shadow-sm
							focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
					/>
				</div>

				<div>
					<label for="new-password" class="block text-sm font-medium text-gray-700 mb-1">
						New Password
					</label>
					<input
						id="new-password"
						type="password"
						bind:value={newPassword}
						class="w-full rounded-md border-gray-300 shadow-sm
							focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
					/>
				</div>

				<div>
					<label for="confirm-password" class="block text-sm font-medium text-gray-700 mb-1">
						Confirm New Password
					</label>
					<input
						id="confirm-password"
						type="password"
						bind:value={confirmPassword}
						class="w-full rounded-md border-gray-300 shadow-sm
							focus:border-blue-500 focus:ring-blue-500 sm:text-sm"
					/>
				</div>

				<div class="flex gap-3">
					<button
						on:click={handleChangePassword}
						disabled={loading || !currentPassword || !newPassword || !confirmPassword}
						class="px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-lg
							hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
							disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors duration-200"
					>
						{loading ? 'Changing...' : 'Change Password'}
					</button>
					<button
						on:click={cancel}
						class="px-4 py-2 text-gray-600 text-sm font-medium rounded-lg
							hover:bg-gray-100 transition-colors duration-200"
					>
						Cancel
					</button>
				</div>
			</div>
		{/if}
	</div>
</main>
