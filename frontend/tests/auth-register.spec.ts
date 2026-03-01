import { test, expect } from './helpers/fixtures';
import { uniqueEmail } from './helpers/auth-test-utils';

test.describe('Registration', () => {
	test('successful registration redirects to dashboard', async ({ page }) => {
		const email = uniqueEmail('reg');
		await page.goto('/register');

		await page.getByLabel('Email').fill(email);
		await page.getByLabel('Password', { exact: true }).fill('SecurePass123!');
		await page.getByLabel('Confirm Password').fill('SecurePass123!');
		await page.getByRole('button', { name: 'Create Account' }).click();

		await page.waitForURL('/dashboard');
		expect(page.url()).toContain('/dashboard');
	});

	test('registration stores token in localStorage', async ({ page }) => {
		const email = uniqueEmail('reg');
		await page.goto('/register');

		await page.getByLabel('Email').fill(email);
		await page.getByLabel('Password', { exact: true }).fill('SecurePass123!');
		await page.getByLabel('Confirm Password').fill('SecurePass123!');
		await page.getByRole('button', { name: 'Create Account' }).click();

		await page.waitForURL('/dashboard');
		const token = await page.evaluate(() => localStorage.getItem('sertantai_token'));
		expect(token).toBeTruthy();
	});

	test('shows error when email is missing', async ({ page }) => {
		await page.goto('/register');

		await page.getByLabel('Password', { exact: true }).fill('SecurePass123!');
		await page.getByLabel('Confirm Password').fill('SecurePass123!');
		await page.getByRole('button', { name: 'Create Account' }).click();

		await expect(page.getByText('Email is required')).toBeVisible();
	});

	test('shows error for invalid email format', async ({ page }) => {
		await page.goto('/register');

		// Use fill on the raw input to bypass browser's type="email" native validation
		const emailInput = page.getByLabel('Email');
		await emailInput.evaluate((el: HTMLInputElement) => {
			el.type = 'text';
		});
		await emailInput.fill('not-an-email');
		await page.getByLabel('Password', { exact: true }).fill('SecurePass123!');
		await page.getByLabel('Confirm Password').fill('SecurePass123!');
		await page.getByRole('button', { name: 'Create Account' }).click();

		await expect(page.getByText('Invalid email format')).toBeVisible();
	});

	test('shows error when password is too short', async ({ page }) => {
		await page.goto('/register');

		await page.getByLabel('Email').fill(uniqueEmail('reg'));
		await page.getByLabel('Password', { exact: true }).fill('short');
		await page.getByLabel('Confirm Password').fill('short');
		await page.getByRole('button', { name: 'Create Account' }).click();

		await expect(page.getByText('Password must be at least 8 characters')).toBeVisible();
	});

	test('shows error when passwords do not match', async ({ page }) => {
		await page.goto('/register');

		await page.getByLabel('Email').fill(uniqueEmail('reg'));
		await page.getByLabel('Password', { exact: true }).fill('SecurePass123!');
		await page.getByLabel('Confirm Password').fill('DifferentPass456!');
		await page.getByRole('button', { name: 'Create Account' }).click();

		await expect(page.getByText('Passwords do not match')).toBeVisible();
	});

	test('shows error for duplicate email', async ({ page, createUser }) => {
		const user = await createUser();

		await page.goto('/register');
		await page.getByLabel('Email').fill(user.email);
		await page.getByLabel('Password', { exact: true }).fill('SecurePass123!');
		await page.getByLabel('Confirm Password').fill('SecurePass123!');
		await page.getByRole('button', { name: 'Create Account' }).click();

		await expect(page.locator('.text-red-600')).toBeVisible();
	});

	test('has link to sign in page', async ({ page }) => {
		await page.goto('/register');

		const link = page.locator('main').getByRole('link', { name: 'Sign in' });
		await expect(link).toBeVisible();
		await link.click();

		await page.waitForURL('/login');
	});
});
