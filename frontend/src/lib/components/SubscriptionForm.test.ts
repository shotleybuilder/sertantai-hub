import { describe, it, expect } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/svelte';
import SubscriptionForm from './SubscriptionForm.svelte';
import type { Subscription, CreateSubscriptionParams } from '$lib/types/notifications';

function makeSub(): Subscription {
	return {
		id: '1',
		organization_id: 'org-1',
		user_id: 'user-1',
		name: 'Climate Laws',
		law_families: ['E:CLIMATE', 'HS:HEALTH'],
		geo_extent: ['S'],
		change_types: ['new'],
		keywords: ['emissions'],
		type_codes: ['ukpga'],
		frequency: 'immediate',
		delivery_methods: ['email'],
		enabled: true,
		inserted_at: '2026-01-01T00:00:00Z',
		updated_at: '2026-01-01T00:00:00Z'
	};
}

describe('SubscriptionForm', () => {
	it('renders empty form when no subscription', () => {
		render(SubscriptionForm);
		const nameInput = screen.getByLabelText('Name') as HTMLInputElement;
		expect(nameInput.value).toBe('');
		expect(screen.getByText('Create')).toBeTruthy();
	});

	it('pre-fills form when editing an existing subscription', () => {
		const sub = makeSub();
		render(SubscriptionForm, { props: { subscription: sub } });

		const nameInput = screen.getByLabelText('Name') as HTMLInputElement;
		expect(nameInput.value).toBe('Climate Laws');

		const familiesInput = screen.getByLabelText('Law Families') as HTMLInputElement;
		expect(familiesInput.value).toBe('E:CLIMATE, HS:HEALTH');

		const freqSelect = screen.getByLabelText('Frequency') as HTMLSelectElement;
		expect(freqSelect.value).toBe('immediate');

		expect(screen.getByText('Update')).toBeTruthy();
	});

	it('shows Saving... when loading', () => {
		render(SubscriptionForm, { props: { loading: true, subscription: makeSub() } });
		expect(screen.getByText('Saving...')).toBeTruthy();
	});

	it('disables submit button when name is empty', () => {
		render(SubscriptionForm);
		const submitBtn = screen.getByText('Create') as HTMLButtonElement;
		expect(submitBtn.disabled).toBe(true);
	});

	it('dispatches submit event with parsed data', async () => {
		const { component } = render(SubscriptionForm);

		let submitPayload: CreateSubscriptionParams | undefined;
		component.$on('submit', (e: CustomEvent<CreateSubscriptionParams>) => {
			submitPayload = e.detail;
		});

		const nameInput = screen.getByLabelText('Name') as HTMLInputElement;
		await fireEvent.input(nameInput, { target: { value: 'Test Sub' } });

		const familiesInput = screen.getByLabelText('Law Families') as HTMLInputElement;
		await fireEvent.input(familiesInput, { target: { value: 'E:CLIMATE, HS:HEALTH' } });

		const keywordsInput = screen.getByLabelText('Keywords') as HTMLInputElement;
		await fireEvent.input(keywordsInput, { target: { value: 'carbon, emissions' } });

		const form = nameInput.closest('form')!;
		await fireEvent.submit(form);

		expect(submitPayload).toBeDefined();
		expect(submitPayload!.name).toBe('Test Sub');
		expect(submitPayload!.law_families).toEqual(['E:CLIMATE', 'HS:HEALTH']);
		expect(submitPayload!.keywords).toEqual(['carbon', 'emissions']);
		expect(submitPayload!.frequency).toBe('daily_digest');
	});

	it('dispatches cancel event', async () => {
		const { component } = render(SubscriptionForm);

		let cancelled = false;
		component.$on('cancel', () => {
			cancelled = true;
		});

		const cancelBtn = screen.getByText('Cancel');
		await fireEvent.click(cancelBtn);
		expect(cancelled).toBe(true);
	});

	it('parses comma-separated lists correctly, trimming whitespace', async () => {
		const { component } = render(SubscriptionForm);

		let submitPayload: CreateSubscriptionParams | undefined;
		component.$on('submit', (e: CustomEvent<CreateSubscriptionParams>) => {
			submitPayload = e.detail;
		});

		await fireEvent.input(screen.getByLabelText('Name'), { target: { value: 'Test' } });
		await fireEvent.input(screen.getByLabelText('Geographic Extent'), {
			target: { value: '  S , E+W ,  ' }
		});

		const form = screen.getByLabelText('Name').closest('form')!;
		await fireEvent.submit(form);

		expect(submitPayload!.geo_extent).toEqual(['S', 'E+W']);
	});

	it('sends empty arrays for blank filter fields', async () => {
		const { component } = render(SubscriptionForm);

		let submitPayload: CreateSubscriptionParams | undefined;
		component.$on('submit', (e: CustomEvent<CreateSubscriptionParams>) => {
			submitPayload = e.detail;
		});

		await fireEvent.input(screen.getByLabelText('Name'), { target: { value: 'Minimal' } });

		const form = screen.getByLabelText('Name').closest('form')!;
		await fireEvent.submit(form);

		expect(submitPayload!.law_families).toEqual([]);
		expect(submitPayload!.geo_extent).toEqual([]);
		expect(submitPayload!.change_types).toEqual([]);
		expect(submitPayload!.keywords).toEqual([]);
		expect(submitPayload!.type_codes).toEqual([]);
	});
});
