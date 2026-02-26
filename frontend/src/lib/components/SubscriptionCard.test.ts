import { describe, it, expect } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/svelte';
import SubscriptionCard from './SubscriptionCard.svelte';
import type { Subscription } from '$lib/types/notifications';

function makeSub(overrides: Partial<Subscription> = {}): Subscription {
	return {
		id: '1',
		organization_id: 'org-1',
		user_id: 'user-1',
		name: 'Climate Laws',
		law_families: ['E:CLIMATE'],
		geo_extent: ['S'],
		change_types: ['new'],
		keywords: ['emissions'],
		type_codes: ['ukpga'],
		frequency: 'daily_digest',
		delivery_methods: ['email'],
		enabled: true,
		inserted_at: '2026-01-01T00:00:00Z',
		updated_at: '2026-01-01T00:00:00Z',
		...overrides
	};
}

describe('SubscriptionCard', () => {
	it('renders the subscription name', () => {
		render(SubscriptionCard, { props: { subscription: makeSub() } });
		expect(screen.getByText('Climate Laws')).toBeTruthy();
	});

	it('renders frequency badge', () => {
		render(SubscriptionCard, { props: { subscription: makeSub() } });
		expect(screen.getByText('Daily Digest')).toBeTruthy();
	});

	it('renders filter summary', () => {
		render(SubscriptionCard, { props: { subscription: makeSub() } });
		expect(screen.getByText('Families: E:CLIMATE')).toBeTruthy();
		expect(screen.getByText('Extent: S')).toBeTruthy();
		expect(screen.getByText('Types: new')).toBeTruthy();
		expect(screen.getByText('Keywords: emissions')).toBeTruthy();
		expect(screen.getByText('Codes: ukpga')).toBeTruthy();
	});

	it('shows "All law changes" when no filters', () => {
		render(SubscriptionCard, {
			props: {
				subscription: makeSub({
					law_families: [],
					geo_extent: [],
					change_types: [],
					keywords: [],
					type_codes: []
				})
			}
		});
		expect(screen.getByText('All law changes (no filters)')).toBeTruthy();
	});

	it('shows Paused badge when disabled', () => {
		render(SubscriptionCard, {
			props: { subscription: makeSub({ enabled: false }) }
		});
		expect(screen.getByText('Paused')).toBeTruthy();
	});

	it('does not show Paused badge when enabled', () => {
		render(SubscriptionCard, { props: { subscription: makeSub() } });
		expect(screen.queryByText('Paused')).toBeNull();
	});

	it('dispatches edit event on edit button click', async () => {
		const sub = makeSub();
		const { component } = render(SubscriptionCard, { props: { subscription: sub } });

		let editPayload: Subscription | undefined;
		component.$on('edit', (e: CustomEvent<Subscription>) => {
			editPayload = e.detail;
		});

		const editBtn = screen.getByTitle('Edit');
		await fireEvent.click(editBtn);
		expect(editPayload).toEqual(sub);
	});

	it('dispatches delete event on delete button click', async () => {
		const sub = makeSub();
		const { component } = render(SubscriptionCard, { props: { subscription: sub } });

		let deletePayload: Subscription | undefined;
		component.$on('delete', (e: CustomEvent<Subscription>) => {
			deletePayload = e.detail;
		});

		const deleteBtn = screen.getByTitle('Delete');
		await fireEvent.click(deleteBtn);
		expect(deletePayload).toEqual(sub);
	});

	it('dispatches toggle event on toggle button click', async () => {
		const sub = makeSub();
		const { component } = render(SubscriptionCard, { props: { subscription: sub } });

		let togglePayload: Subscription | undefined;
		component.$on('toggle', (e: CustomEvent<Subscription>) => {
			togglePayload = e.detail;
		});

		const toggleBtn = screen.getByTitle('Pause');
		await fireEvent.click(toggleBtn);
		expect(togglePayload).toEqual(sub);
	});

	it('shows Enable title when disabled', () => {
		render(SubscriptionCard, {
			props: { subscription: makeSub({ enabled: false }) }
		});
		expect(screen.getByTitle('Enable')).toBeTruthy();
	});
});
