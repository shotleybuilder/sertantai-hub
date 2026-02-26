export interface Subscription {
	id: string;
	organization_id: string;
	user_id: string | null;
	name: string;
	law_families: string[];
	geo_extent: string[];
	change_types: string[];
	keywords: string[];
	type_codes: string[];
	frequency: 'immediate' | 'daily_digest' | 'weekly_digest';
	delivery_methods: string[];
	enabled: boolean;
	inserted_at: string;
	updated_at: string;
}

export interface LawChangeEvent {
	id: string;
	organization_id: string;
	subscription_id: string;
	law_name: string;
	law_title: string;
	change_type: string;
	families: string[];
	summary: string | null;
	delivered_at: string | null;
	batch_id: string | null;
	inserted_at: string;
}

export interface CreateSubscriptionParams {
	name: string;
	law_families?: string[];
	geo_extent?: string[];
	change_types?: string[];
	keywords?: string[];
	type_codes?: string[];
	frequency?: string;
	delivery_methods?: string[];
}

export interface UpdateSubscriptionParams {
	name?: string;
	law_families?: string[];
	geo_extent?: string[];
	change_types?: string[];
	keywords?: string[];
	type_codes?: string[];
	frequency?: string;
	delivery_methods?: string[];
	enabled?: boolean;
}
