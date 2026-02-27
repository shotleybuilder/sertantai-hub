import { describe, it, expect, vi, beforeEach } from 'vitest';

// Mock the client module
vi.mock('./client', () => ({
	apiFetch: vi.fn()
}));

import { apiFetch } from './client';
import { getProfile, updateProfile, changePassword } from './profile';

const mockApiFetch = vi.mocked(apiFetch);

function mockResponse(status: number, data: unknown): Response {
	return {
		ok: status >= 200 && status < 300,
		status,
		json: () => Promise.resolve(data)
	} as Response;
}

beforeEach(() => {
	mockApiFetch.mockReset();
});

describe('getProfile', () => {
	it('returns user profile on success', async () => {
		const user = { id: '1', email: 'test@example.com', name: 'Test', role: 'owner' };
		mockApiFetch.mockResolvedValue(mockResponse(200, { status: 'success', user }));

		const result = await getProfile();
		expect(result.ok).toBe(true);
		expect(result.data).toEqual(user);
		expect(mockApiFetch).toHaveBeenCalledWith('/api/auth/profile');
	});

	it('returns error on failure', async () => {
		mockApiFetch.mockResolvedValue(mockResponse(401, { message: 'Authentication required' }));

		const result = await getProfile();
		expect(result.ok).toBe(false);
		expect(result.error).toBe('Authentication required');
	});

	it('handles network errors', async () => {
		mockApiFetch.mockRejectedValue(new Error('Network failure'));

		const result = await getProfile();
		expect(result.ok).toBe(false);
		expect(result.error).toBe('Network failure');
	});
});

describe('updateProfile', () => {
	it('wraps params in user key when sending to API', async () => {
		const user = { id: '1', email: 'test@example.com', name: 'New Name', role: 'owner' };
		mockApiFetch.mockResolvedValue(mockResponse(200, { status: 'success', user }));

		await updateProfile({ name: 'New Name' });

		// The API expects {"user": {"name": "..."}} not just {"name": "..."}
		expect(mockApiFetch).toHaveBeenCalledWith('/api/auth/profile', {
			method: 'PATCH',
			body: JSON.stringify({ user: { name: 'New Name' } })
		});
	});

	it('wraps email updates in user key', async () => {
		const user = { id: '1', email: 'new@example.com', name: 'Test', role: 'owner' };
		mockApiFetch.mockResolvedValue(mockResponse(200, { status: 'success', user }));

		await updateProfile({ email: 'new@example.com' });

		expect(mockApiFetch).toHaveBeenCalledWith('/api/auth/profile', {
			method: 'PATCH',
			body: JSON.stringify({ user: { email: 'new@example.com' } })
		});
	});

	it('wraps both name and email in user key', async () => {
		const user = { id: '1', email: 'new@example.com', name: 'New Name', role: 'owner' };
		mockApiFetch.mockResolvedValue(mockResponse(200, { status: 'success', user }));

		await updateProfile({ name: 'New Name', email: 'new@example.com' });

		expect(mockApiFetch).toHaveBeenCalledWith('/api/auth/profile', {
			method: 'PATCH',
			body: JSON.stringify({ user: { name: 'New Name', email: 'new@example.com' } })
		});
	});

	it('returns updated user on success', async () => {
		const user = { id: '1', email: 'test@example.com', name: 'Updated', role: 'owner' };
		mockApiFetch.mockResolvedValue(mockResponse(200, { status: 'success', user }));

		const result = await updateProfile({ name: 'Updated' });
		expect(result.ok).toBe(true);
		expect(result.data).toEqual(user);
	});

	it('returns error on failure', async () => {
		mockApiFetch.mockResolvedValue(mockResponse(400, { message: "Missing 'user' parameter" }));

		const result = await updateProfile({ name: 'Test' });
		expect(result.ok).toBe(false);
		expect(result.error).toBe("Missing 'user' parameter");
	});
});

describe('changePassword', () => {
	it('sends correct params', async () => {
		mockApiFetch.mockResolvedValue(
			mockResponse(200, { status: 'success', message: 'Password changed' })
		);

		await changePassword('old123', 'new456');

		expect(mockApiFetch).toHaveBeenCalledWith('/api/auth/profile/change-password', {
			method: 'POST',
			body: JSON.stringify({ current_password: 'old123', new_password: 'new456' })
		});
	});

	it('returns ok on success', async () => {
		mockApiFetch.mockResolvedValue(
			mockResponse(200, { status: 'success', message: 'Password changed' })
		);

		const result = await changePassword('old123', 'new456');
		expect(result.ok).toBe(true);
	});

	it('returns error on failure', async () => {
		mockApiFetch.mockResolvedValue(mockResponse(422, { message: 'Wrong current password' }));

		const result = await changePassword('wrong', 'new456');
		expect(result.ok).toBe(false);
		expect(result.error).toBe('Wrong current password');
	});
});
