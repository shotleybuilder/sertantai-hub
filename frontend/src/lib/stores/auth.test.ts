import { describe, it, expect } from 'vitest';

describe('auth store', () => {
	it('should export initial auth state', async () => {
		const { authStore } = await import('./auth');
		let state: unknown;
		const unsubscribe = authStore.subscribe((s) => (state = s));
		expect(state).toHaveProperty('isAuthenticated', false);
		expect(state).toHaveProperty('token', null);
		unsubscribe();
	});
});
