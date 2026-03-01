import { test, expect } from './helpers/fixtures';

test.describe('GitHub OAuth', () => {
	test.describe('Login page', () => {
		test('shows "Sign in with GitHub" button', async ({ page }) => {
			await page.goto('/login');

			const githubButton = page.getByRole('link', { name: 'Sign in with GitHub' });
			await expect(githubButton).toBeVisible();
		});

		test('GitHub button links to hub auth proxy redirect', async ({ page }) => {
			await page.goto('/login');

			const githubButton = page.getByRole('link', { name: 'Sign in with GitHub' });
			const href = await githubButton.getAttribute('href');
			expect(href).toMatch(/\/api\/auth\/github$/);
		});
	});

	test.describe('Callback page', () => {
		test('valid token authenticates and redirects to dashboard', async ({ page, createUser }) => {
			// Seed a user to get a valid JWT (same format as GitHub OAuth would produce)
			const user = await createUser();

			await page.goto(`/auth/callback?token=${user.token}`);

			await expect(page.getByText("You're signed in!")).toBeVisible();
			await page.waitForURL('/dashboard', { timeout: 5000 });

			// Verify token was stored in localStorage
			const storedToken = await page.evaluate(() => localStorage.getItem('sertantai_token'));
			expect(storedToken).toBe(user.token);
		});

		test('error param shows user-friendly error message', async ({ page }) => {
			await page.goto('/auth/callback?error=oauth_failed');

			await expect(page.getByText('GitHub authentication failed. Please try again.')).toBeVisible();
			await expect(page.getByRole('link', { name: 'Back to Sign In' })).toBeVisible();
		});

		test('account_deactivated error shows deactivation message', async ({ page }) => {
			await page.goto('/auth/callback?error=account_deactivated');

			await expect(
				page.getByText('Your account has been deactivated. Please contact support.')
			).toBeVisible();
		});

		test('access_denied error shows denial message', async ({ page }) => {
			await page.goto('/auth/callback?error=access_denied');

			await expect(
				page.getByText('Access was denied. Please try again or use a different sign-in method.')
			).toBeVisible();
		});

		test('unknown error code shows generic message', async ({ page }) => {
			await page.goto('/auth/callback?error=something_unexpected');

			await expect(page.getByText('Authentication failed. Please try again.')).toBeVisible();
		});

		test('no token and no error shows missing token message', async ({ page }) => {
			await page.goto('/auth/callback');

			await expect(page.getByText('No authentication token received')).toBeVisible();
			await expect(page.getByRole('link', { name: 'Back to Sign In' })).toBeVisible();
		});

		test('Back to Sign In link navigates to login page', async ({ page }) => {
			await page.goto('/auth/callback?error=oauth_failed');

			await page.getByRole('link', { name: 'Back to Sign In' }).click();
			await page.waitForURL('/login');
		});
	});
});
