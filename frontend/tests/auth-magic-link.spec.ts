import { test, expect } from './helpers/fixtures';
import { uniqueEmail, resetTestData, waitForEmail } from './helpers/auth-test-utils';

test.describe('Magic Link', () => {
	test.beforeEach(async () => {
		await resetTestData({ clear_emails: true, clear_rate_limiter: true });
	});

	test('requesting a magic link shows success message', async ({ page, createUser }) => {
		const user = await createUser();

		await page.goto('/login');
		await page.getByLabel('Email').fill(user.email);
		await page.getByRole('button', { name: 'Send Magic Link' }).click();

		await expect(page.getByText('Check your email for a magic link')).toBeVisible();
	});

	test('full magic link flow: request, retrieve token, authenticate', async ({
		page,
		createUser
	}) => {
		const user = await createUser();

		// Request magic link via the UI
		await page.goto('/login');
		await page.getByLabel('Email').fill(user.email);
		await page.getByRole('button', { name: 'Send Magic Link' }).click();
		await expect(page.getByText('Check your email for a magic link')).toBeVisible();

		// Retrieve the token from the test email endpoint
		const email = await waitForEmail(user.email, { timeout: 15000 });
		expect(email.token).toBeTruthy();

		// Navigate to the magic link callback with the token
		await page.goto(`/auth/magic-link?token=${email.token}`);

		// Should show success and redirect to dashboard
		await expect(page.getByText("You're signed in!")).toBeVisible();
		await page.waitForURL('/dashboard', { timeout: 5000 });
	});

	test('invalid magic link token shows error', async ({ page }) => {
		await page.goto('/auth/magic-link?token=invalid-token-123');

		await expect(page.locator('.text-red-500')).toBeVisible();
		await expect(page.getByRole('link', { name: 'Back to Sign In' })).toBeVisible();
	});

	test('missing token shows error message', async ({ page }) => {
		await page.goto('/auth/magic-link');

		await expect(page.getByText('No token found')).toBeVisible();
	});

	test('magic link request for non-existent email still shows success', async ({ page }) => {
		// Auth service returns 200 regardless to prevent user enumeration
		await page.goto('/login');
		await page.getByLabel('Email').fill(uniqueEmail('nouser'));
		await page.getByRole('button', { name: 'Send Magic Link' }).click();

		await expect(page.getByText('Check your email for a magic link')).toBeVisible();
	});

	test('magic link request requires email', async ({ page }) => {
		await page.goto('/login');
		await page.getByRole('button', { name: 'Send Magic Link' }).click();

		await expect(page.getByText('Email is required')).toBeVisible();
	});

	test('magic link request validates email format', async ({ page }) => {
		await page.goto('/login');
		await page.getByLabel('Email').fill('not-an-email');
		await page.getByRole('button', { name: 'Send Magic Link' }).click();

		await expect(page.getByText('Invalid email format')).toBeVisible();
	});
});
