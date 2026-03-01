/**
 * Test utilities for sertantai-auth dev/test endpoints.
 * These call the auth service directly (not through the hub proxy)
 * to seed users, retrieve emails, and manage test state.
 */
import { TOTP } from 'otpauth';

const AUTH_URL = process.env.AUTH_TEST_URL || 'http://localhost:4000';

// --- Types ---

export interface SeedUserOptions {
	email?: string;
	password?: string;
	role?: 'owner' | 'admin' | 'member' | 'viewer';
	name?: string;
	totp?: boolean;
	tier?: 'free' | 'standard' | 'premium';
}

export interface SeededUser {
	user_id: string;
	email: string;
	org_id: string;
	org_name: string;
	role: string;
	token: string;
	password: string;
	totp_secret?: string;
	backup_codes?: string[];
}

export interface TestEmail {
	to: { name: string; address: string }[];
	from: { name: string; address: string };
	subject: string;
	text_body: string;
	token?: string;
	stored_at: string;
}

export interface ResetOptions {
	clear_emails?: boolean;
	clear_rate_limiter?: boolean;
	delete_users_matching?: string;
}

// --- Seed & Reset ---

/**
 * Create a test user via sertantai-auth's dev seed endpoint.
 * Returns full user details including password, and TOTP secrets if requested.
 */
export async function seedUser(opts: SeedUserOptions = {}): Promise<SeededUser> {
	const body = { ...opts };
	if (!body.email) {
		body.email = uniqueEmail('seed');
	}

	const response = await fetch(`${AUTH_URL}/dev/test/seed`, {
		method: 'POST',
		headers: { 'Content-Type': 'application/json' },
		body: JSON.stringify(body)
	});

	if (!response.ok) {
		const body = await response.text();
		throw new Error(`Failed to seed user (${response.status}): ${body}`);
	}

	return response.json();
}

/**
 * Reset test state — clear emails, rate limiter, optionally delete users.
 */
export async function resetTestData(opts: ResetOptions = {}): Promise<void> {
	const response = await fetch(`${AUTH_URL}/dev/test/reset`, {
		method: 'POST',
		headers: { 'Content-Type': 'application/json' },
		body: JSON.stringify(opts)
	});

	if (!response.ok) {
		const body = await response.text();
		throw new Error(`Failed to reset test data (${response.status}): ${body}`);
	}
}

// --- Email Retrieval ---

/**
 * Retrieve emails sent to a given address via the auth service's test email store.
 * Useful for extracting magic link and confirmation tokens.
 */
export async function getEmails(email: string): Promise<TestEmail[]> {
	const response = await fetch(`${AUTH_URL}/dev/test/emails?to=${encodeURIComponent(email)}`);

	if (!response.ok) {
		const body = await response.text();
		throw new Error(`Failed to get emails (${response.status}): ${body}`);
	}

	const data = await response.json();
	return data.emails;
}

/**
 * Clear all stored test emails.
 */
export async function clearEmails(): Promise<void> {
	const response = await fetch(`${AUTH_URL}/dev/test/emails`, {
		method: 'DELETE'
	});

	if (!response.ok) {
		const body = await response.text();
		throw new Error(`Failed to clear emails (${response.status}): ${body}`);
	}
}

/**
 * Wait for an email to arrive for the given address, polling until found or timeout.
 * Returns the first matching email.
 */
export async function waitForEmail(
	email: string,
	opts: { timeout?: number; interval?: number; subject?: string } = {}
): Promise<TestEmail> {
	const timeout = opts.timeout ?? 10_000;
	const interval = opts.interval ?? 500;
	const deadline = Date.now() + timeout;

	while (Date.now() < deadline) {
		const emails = await getEmails(email);
		const match = opts.subject ? emails.find((e) => e.subject.includes(opts.subject!)) : emails[0];

		if (match) return match;
		await new Promise((r) => setTimeout(r, interval));
	}

	throw new Error(`No email received for ${email} within ${timeout}ms`);
}

// --- TOTP ---

/**
 * Generate a valid 6-digit TOTP code from a base32 secret.
 */
export function generateTotpCode(secret: string): string {
	const totp = new TOTP({
		secret,
		digits: 6,
		period: 30,
		algorithm: 'SHA1'
	});

	return totp.generate();
}

// --- Unique Test Data ---

/**
 * Generate a unique email address for test isolation.
 * Uses timestamp + random suffix to avoid collisions across parallel runs.
 */
export function uniqueEmail(prefix = 'test'): string {
	const ts = Date.now();
	const rand = Math.random().toString(36).substring(2, 6);
	return `${prefix}+${ts}-${rand}@test.sertantai.com`;
}
