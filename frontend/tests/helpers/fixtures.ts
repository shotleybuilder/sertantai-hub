/**
 * Playwright test fixtures for auth E2E tests.
 * Extends the base test with automatic test data cleanup
 * and convenient helper access.
 */
import { test as base, type Page } from '@playwright/test';
import { resetTestData, seedUser, type SeedUserOptions, type SeededUser } from './auth-test-utils';

type AuthFixtures = {
	/** Seed a user and return their details. Cleans up test data after each test. */
	createUser: (opts?: SeedUserOptions) => Promise<SeededUser>;
	/** Log in as a seeded user via the UI. Returns the seeded user details. */
	loginAsUser: (opts?: SeedUserOptions) => Promise<SeededUser>;
};

export const test = base.extend<AuthFixtures>({
	createUser: async ({}, use) => {
		const users: SeededUser[] = [];

		const fn = async (opts: SeedUserOptions = {}) => {
			const user = await seedUser(opts);
			users.push(user);
			return user;
		};

		await use(fn);

		// Cleanup: delete seeded users by email pattern
		for (const user of users) {
			await resetTestData({ delete_users_matching: user.email }).catch(() => {});
		}
	},

	loginAsUser: async ({ page, createUser }, use) => {
		const fn = async (opts: SeedUserOptions = {}) => {
			const user = await createUser(opts);
			await loginViaUI(page, user.email, user.password);
			return user;
		};

		await use(fn);
	}
});

export { expect } from '@playwright/test';

/**
 * Log in through the login page UI.
 */
async function loginViaUI(page: Page, email: string, password: string): Promise<void> {
	await page.goto('/login');
	await page.getByLabel('Email').fill(email);
	await page.getByLabel('Password').fill(password);
	await page.getByRole('button', { name: 'Sign In' }).click();
	await page.waitForURL('/dashboard');
}
