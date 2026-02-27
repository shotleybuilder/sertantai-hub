import { describe, it, expect, vi, beforeEach } from 'vitest';

// Mock the client module
vi.mock('./client', () => ({
	apiFetch: vi.fn()
}));

import { apiFetch } from './client';
import { getOrganization, updateOrganization } from './organization';

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

describe('getOrganization', () => {
	it('returns organization on success', async () => {
		const org = { id: '1', name: 'Test Org', slug: 'test-org', tier: 'free', settings: {} };
		mockApiFetch.mockResolvedValue(mockResponse(200, { status: 'success', organization: org }));

		const result = await getOrganization();
		expect(result.ok).toBe(true);
		expect(result.data).toEqual(org);
		expect(mockApiFetch).toHaveBeenCalledWith('/api/auth/organization');
	});

	it('returns error on failure', async () => {
		mockApiFetch.mockResolvedValue(mockResponse(401, { message: 'Authentication required' }));

		const result = await getOrganization();
		expect(result.ok).toBe(false);
		expect(result.error).toBe('Authentication required');
	});

	it('handles network errors', async () => {
		mockApiFetch.mockRejectedValue(new Error('Network failure'));

		const result = await getOrganization();
		expect(result.ok).toBe(false);
		expect(result.error).toBe('Network failure');
	});
});

describe('updateOrganization', () => {
	it('wraps params in organization key when sending to API', async () => {
		const org = { id: '1', name: 'New Name', slug: 'test-org', tier: 'free', settings: {} };
		mockApiFetch.mockResolvedValue(mockResponse(200, { status: 'success', organization: org }));

		await updateOrganization({ name: 'New Name' });

		expect(mockApiFetch).toHaveBeenCalledWith('/api/auth/organization', {
			method: 'PATCH',
			body: JSON.stringify({ organization: { name: 'New Name' } })
		});
	});

	it('returns updated organization on success', async () => {
		const org = { id: '1', name: 'Updated', slug: 'test-org', tier: 'free', settings: {} };
		mockApiFetch.mockResolvedValue(mockResponse(200, { status: 'success', organization: org }));

		const result = await updateOrganization({ name: 'Updated' });
		expect(result.ok).toBe(true);
		expect(result.data).toEqual(org);
	});

	it('returns error on failure', async () => {
		mockApiFetch.mockResolvedValue(
			mockResponse(400, { message: "Missing 'organization' parameter" })
		);

		const result = await updateOrganization({ name: 'Test' });
		expect(result.ok).toBe(false);
		expect(result.error).toBe("Missing 'organization' parameter");
	});

	it('handles network errors', async () => {
		mockApiFetch.mockRejectedValue(new Error('Network failure'));

		const result = await updateOrganization({ name: 'Test' });
		expect(result.ok).toBe(false);
		expect(result.error).toBe('Network failure');
	});
});
