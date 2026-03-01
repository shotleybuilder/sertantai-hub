import { test, expect } from './helpers/fixtures';
import { generateTotpCode } from './helpers/auth-test-utils';

test.describe('TOTP Login Challenge', () => {
	test('login with TOTP redirects to challenge then authenticates', async ({
		page,
		createUser
	}) => {
		const user = await createUser({ totp: true });

		await page.goto('/login');
		await page.getByLabel('Email').fill(user.email);
		await page.getByLabel('Password').fill(user.password);
		await page.getByRole('button', { name: 'Sign In' }).click();

		// Should redirect to TOTP challenge page
		await page.waitForURL(/\/auth\/totp-challenge/);
		await expect(page.getByText('Two-Factor Authentication')).toBeVisible();

		// Enter valid TOTP code
		const code = generateTotpCode(user.totp_secret!);
		await page.getByPlaceholder('000000').fill(code);
		await page.getByRole('button', { name: 'Verify' }).click();

		await page.waitForURL('/dashboard');
	});

	test('invalid TOTP code shows error', async ({ page, createUser }) => {
		const user = await createUser({ totp: true });

		await page.goto('/login');
		await page.getByLabel('Email').fill(user.email);
		await page.getByLabel('Password').fill(user.password);
		await page.getByRole('button', { name: 'Sign In' }).click();

		await page.waitForURL(/\/auth\/totp-challenge/);

		await page.getByPlaceholder('000000').fill('000000');
		await page.getByRole('button', { name: 'Verify' }).click();

		await expect(page.locator('.text-red-600')).toBeVisible();
		expect(page.url()).toContain('/auth/totp-challenge');
	});

	test('backup code recovery authenticates successfully', async ({ page, createUser }) => {
		const user = await createUser({ totp: true });

		await page.goto('/login');
		await page.getByLabel('Email').fill(user.email);
		await page.getByLabel('Password').fill(user.password);
		await page.getByRole('button', { name: 'Sign In' }).click();

		await page.waitForURL(/\/auth\/totp-challenge/);

		// Switch to backup code mode
		await page.getByText('Use a backup code').click();

		// Enter a valid backup code
		const backupCode = user.backup_codes![0];
		await page.getByPlaceholder('ABCD1234').fill(backupCode);
		await page.getByRole('button', { name: 'Verify Backup Code' }).click();

		await page.waitForURL('/dashboard');
	});

	test('invalid backup code shows error', async ({ page, createUser }) => {
		const user = await createUser({ totp: true });

		await page.goto('/login');
		await page.getByLabel('Email').fill(user.email);
		await page.getByLabel('Password').fill(user.password);
		await page.getByRole('button', { name: 'Sign In' }).click();

		await page.waitForURL(/\/auth\/totp-challenge/);

		await page.getByText('Use a backup code').click();
		await page.getByPlaceholder('ABCD1234').fill('INVALID1');
		await page.getByRole('button', { name: 'Verify Backup Code' }).click();

		await expect(page.locator('.text-red-600')).toBeVisible();
		expect(page.url()).toContain('/auth/totp-challenge');
	});

	test('can switch between TOTP and backup code modes', async ({ page, createUser }) => {
		const user = await createUser({ totp: true });

		await page.goto('/login');
		await page.getByLabel('Email').fill(user.email);
		await page.getByLabel('Password').fill(user.password);
		await page.getByRole('button', { name: 'Sign In' }).click();

		await page.waitForURL(/\/auth\/totp-challenge/);

		// Default is TOTP mode
		await expect(page.getByPlaceholder('000000')).toBeVisible();

		// Switch to backup code mode
		await page.getByText('Use a backup code').click();
		await expect(page.getByPlaceholder('ABCD1234')).toBeVisible();

		// Switch back to TOTP mode
		await page.getByText('Use authenticator app instead').click();
		await expect(page.getByPlaceholder('000000')).toBeVisible();
	});

	test('back to sign in link returns to login page', async ({ page, createUser }) => {
		const user = await createUser({ totp: true });

		await page.goto('/login');
		await page.getByLabel('Email').fill(user.email);
		await page.getByLabel('Password').fill(user.password);
		await page.getByRole('button', { name: 'Sign In' }).click();

		await page.waitForURL(/\/auth\/totp-challenge/);

		await page.getByRole('link', { name: 'Back to Sign In' }).click();
		await page.waitForURL('/login');
	});
});

test.describe.serial('TOTP Setup & Management', () => {
	test('enable TOTP from security settings', async ({ page, loginAsUser }) => {
		const user = await loginAsUser();

		// Wait for authenticated NavBar to render, then navigate via client-side link
		await expect(page.getByRole('link', { name: 'Settings', exact: true })).toBeVisible({
			timeout: 5000
		});
		await page.getByRole('link', { name: 'Settings', exact: true }).click();
		await page.waitForURL('/settings/security');
		await expect(page.getByRole('heading', { name: 'Security Settings' })).toBeVisible();

		// Start setup
		await page.getByRole('button', { name: 'Enable 2FA' }).click();

		// QR code and secret should be displayed
		await expect(page.getByAltText('TOTP QR Code')).toBeVisible({ timeout: 10000 });
		await expect(page.getByText('Save Backup Codes')).toBeVisible();

		// Get the secret from the page and generate a valid code
		const secret = await page.locator('code').first().textContent();
		expect(secret).toBeTruthy();

		const code = generateTotpCode(secret!);
		await page.getByPlaceholder('000000').fill(code);
		await page.getByRole('button', { name: 'Verify & Enable' }).click();

		await expect(page.getByText('Two-factor authentication has been enabled')).toBeVisible();
		await expect(page.getByText('Enabled', { exact: true })).toBeVisible();
	});

	// Blocked by: https://github.com/shotleybuilder/sertantai-auth/issues/15
	// TOTP status API returns enabled:false for users seeded with totp:true
	test.skip('disable TOTP from security settings', async ({ page, createUser }) => {
		const user = await createUser({ totp: true });

		// Login with TOTP
		await page.goto('/login');
		await page.getByLabel('Email').fill(user.email);
		await page.getByLabel('Password').fill(user.password);
		await page.getByRole('button', { name: 'Sign In' }).click();
		await page.waitForURL(/\/auth\/totp-challenge/);

		const loginCode = generateTotpCode(user.totp_secret!);
		await page.getByPlaceholder('000000').fill(loginCode);
		await page.getByRole('button', { name: 'Verify' }).click();
		await page.waitForURL('/dashboard');

		// Navigate to security settings
		await page.goto('/settings/security');
		await expect(page.getByRole('heading', { name: 'Security Settings' })).toBeVisible();

		const disableButton = page.getByRole('button', { name: 'Disable 2FA' });
		await expect(disableButton).toBeVisible({ timeout: 10000 });

		await disableButton.click();

		const disableCode = generateTotpCode(user.totp_secret!);
		await page.getByPlaceholder('000000').fill(disableCode);
		await page.getByRole('button', { name: 'Disable 2FA' }).click();

		await expect(page.getByText('Two-factor authentication has been disabled')).toBeVisible();
	});

	test('cancel TOTP setup returns to status view', async ({ page, loginAsUser }) => {
		await loginAsUser();

		// Wait for authenticated NavBar to render, then navigate via client-side link
		await expect(page.getByRole('link', { name: 'Settings', exact: true })).toBeVisible({
			timeout: 5000
		});
		await page.getByRole('link', { name: 'Settings', exact: true }).click();
		await page.waitForURL('/settings/security');
		await expect(page.getByRole('heading', { name: 'Security Settings' })).toBeVisible();
		await page.getByRole('button', { name: 'Enable 2FA' }).click();

		await expect(page.getByAltText('TOTP QR Code')).toBeVisible({ timeout: 10000 });

		await page.getByText('Cancel setup').click();

		await expect(page.getByText('Disabled')).toBeVisible();
		await expect(page.getByRole('button', { name: 'Enable 2FA' })).toBeVisible();
	});

	// Blocked by: https://github.com/shotleybuilder/sertantai-auth/issues/15
	// TOTP status API returns enabled:false for users seeded with totp:true
	test.skip('cancel TOTP disable returns to status view', async ({ page, createUser }) => {
		const user = await createUser({ totp: true });

		// Login with TOTP
		await page.goto('/login');
		await page.getByLabel('Email').fill(user.email);
		await page.getByLabel('Password').fill(user.password);
		await page.getByRole('button', { name: 'Sign In' }).click();
		await page.waitForURL(/\/auth\/totp-challenge/);

		const code = generateTotpCode(user.totp_secret!);
		await page.getByPlaceholder('000000').fill(code);
		await page.getByRole('button', { name: 'Verify' }).click();
		await page.waitForURL('/dashboard');

		await page.goto('/settings/security');
		await expect(page.getByRole('heading', { name: 'Security Settings' })).toBeVisible();

		const disableButton = page.getByRole('button', { name: 'Disable 2FA' });
		await expect(disableButton).toBeVisible({ timeout: 10000 });

		await disableButton.click();

		await page.getByText('Cancel').click();

		await expect(disableButton).toBeVisible();
	});
});
