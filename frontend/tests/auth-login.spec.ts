import { test, expect } from './helpers/fixtures';
import { uniqueEmail } from './helpers/auth-test-utils';

test.describe('Login', () => {
	test('successful login redirects to dashboard', async ({ page, createUser }) => {
		const user = await createUser();

		await page.goto('/login');
		await page.getByLabel('Email').fill(user.email);
		await page.getByLabel('Password').fill(user.password);
		await page.getByRole('button', { name: 'Sign In' }).click();

		await page.waitForURL('/dashboard');
		expect(page.url()).toContain('/dashboard');
	});

	test('login stores token in localStorage', async ({ page, createUser }) => {
		const user = await createUser();

		await page.goto('/login');
		await page.getByLabel('Email').fill(user.email);
		await page.getByLabel('Password').fill(user.password);
		await page.getByRole('button', { name: 'Sign In' }).click();

		await page.waitForURL('/dashboard');
		const token = await page.evaluate(() => localStorage.getItem('sertantai_token'));
		expect(token).toBeTruthy();
	});

	test('shows error for invalid password', async ({ page, createUser }) => {
		const user = await createUser();

		await page.goto('/login');
		await page.getByLabel('Email').fill(user.email);
		await page.getByLabel('Password').fill('WrongPassword999!');
		await page.getByRole('button', { name: 'Sign In' }).click();

		await expect(page.locator('.text-red-600')).toBeVisible();
		expect(page.url()).toContain('/login');
	});

	test('shows error for non-existent user', async ({ page }) => {
		await page.goto('/login');
		await page.getByLabel('Email').fill(uniqueEmail('nouser'));
		await page.getByLabel('Password').fill('SecurePass123!');
		await page.getByRole('button', { name: 'Sign In' }).click();

		await expect(page.locator('.text-red-600')).toBeVisible();
		expect(page.url()).toContain('/login');
	});

	test('shows error when email is missing', async ({ page }) => {
		await page.goto('/login');
		await page.getByLabel('Password').fill('SecurePass123!');
		await page.getByRole('button', { name: 'Sign In' }).click();

		await expect(page.getByText('Email is required')).toBeVisible();
	});

	test('shows error when password is missing', async ({ page }) => {
		await page.goto('/login');
		await page.getByLabel('Email').fill(uniqueEmail('nopass'));
		await page.getByRole('button', { name: 'Sign In' }).click();

		await expect(page.getByText('Password is required')).toBeVisible();
	});

	test('shows error for short password', async ({ page }) => {
		await page.goto('/login');
		await page.getByLabel('Email').fill(uniqueEmail('short'));
		await page.getByLabel('Password').fill('short');
		await page.getByRole('button', { name: 'Sign In' }).click();

		await expect(page.getByText('Password must be at least 8 characters')).toBeVisible();
	});

	test('redirects unauthenticated user to login', async ({ page }) => {
		await page.goto('/dashboard');
		await page.waitForURL('/login');
		expect(page.url()).toContain('/login');
	});

	test('has link to register page', async ({ page }) => {
		await page.goto('/login');

		const link = page.locator('main').getByRole('link', { name: 'Register' });
		await expect(link).toBeVisible();
		await link.click();

		await page.waitForURL('/register');
	});
});
