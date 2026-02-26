import { describe, it, expect, vi, beforeEach } from 'vitest';

// Mock the client module
vi.mock('./client', () => ({
	apiFetch: vi.fn()
}));

import { apiFetch } from './client';
import {
	listSubscriptions,
	getSubscription,
	createSubscription,
	updateSubscription,
	deleteSubscription,
	listEvents
} from './subscriptions';

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

describe('listSubscriptions', () => {
	it('returns subscriptions on success', async () => {
		const subs = [{ id: '1', name: 'Test Sub' }];
		mockApiFetch.mockResolvedValue(mockResponse(200, { data: subs }));

		const result = await listSubscriptions();
		expect(result.ok).toBe(true);
		expect(result.data).toEqual(subs);
	});

	it('returns error on failure', async () => {
		mockApiFetch.mockResolvedValue(mockResponse(500, { error: 'Server error' }));

		const result = await listSubscriptions();
		expect(result.ok).toBe(false);
		expect(result.error).toBe('Server error');
	});

	it('handles network errors', async () => {
		mockApiFetch.mockRejectedValue(new Error('Network failure'));

		const result = await listSubscriptions();
		expect(result.ok).toBe(false);
		expect(result.error).toBe('Network failure');
	});
});

describe('getSubscription', () => {
	it('returns a subscription by id', async () => {
		const sub = { id: '1', name: 'Test' };
		mockApiFetch.mockResolvedValue(mockResponse(200, { data: sub }));

		const result = await getSubscription('1');
		expect(result.ok).toBe(true);
		expect(result.data).toEqual(sub);
		expect(mockApiFetch).toHaveBeenCalledWith('/api/subscriptions/1');
	});
});

describe('createSubscription', () => {
	it('creates a subscription', async () => {
		const sub = { id: '1', name: 'New Sub' };
		mockApiFetch.mockResolvedValue(mockResponse(201, { data: sub }));

		const result = await createSubscription({ name: 'New Sub' });
		expect(result.ok).toBe(true);
		expect(result.data).toEqual(sub);
		expect(mockApiFetch).toHaveBeenCalledWith('/api/subscriptions', {
			method: 'POST',
			body: JSON.stringify({ name: 'New Sub' })
		});
	});

	it('returns validation errors', async () => {
		mockApiFetch.mockResolvedValue(mockResponse(422, { error: [{ message: 'name is required' }] }));

		const result = await createSubscription({ name: '' });
		expect(result.ok).toBe(false);
		expect(result.error).toContain('name is required');
	});
});

describe('updateSubscription', () => {
	it('updates a subscription', async () => {
		const sub = { id: '1', name: 'Updated' };
		mockApiFetch.mockResolvedValue(mockResponse(200, { data: sub }));

		const result = await updateSubscription('1', { name: 'Updated' });
		expect(result.ok).toBe(true);
		expect(mockApiFetch).toHaveBeenCalledWith('/api/subscriptions/1', {
			method: 'PATCH',
			body: JSON.stringify({ name: 'Updated' })
		});
	});
});

describe('deleteSubscription', () => {
	it('deletes a subscription', async () => {
		mockApiFetch.mockResolvedValue({ ok: true, status: 204 } as Response);

		const result = await deleteSubscription('1');
		expect(result.ok).toBe(true);
		expect(mockApiFetch).toHaveBeenCalledWith('/api/subscriptions/1', {
			method: 'DELETE'
		});
	});
});

describe('listEvents', () => {
	it('returns events on success', async () => {
		const events = [{ id: '1', law_title: 'Test Act' }];
		mockApiFetch.mockResolvedValue(mockResponse(200, { data: events }));

		const result = await listEvents();
		expect(result.ok).toBe(true);
		expect(result.data).toEqual(events);
	});
});
