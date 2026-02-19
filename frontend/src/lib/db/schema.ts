/**
 * Database schema types
 * Mirrors the backend Ash resource definitions for type-safe frontend usage.
 */

export interface Case {
	id: string;
	title: string;
	description?: string;
	status?: string;
	organization_id: string;
	inserted_at: string;
	updated_at: string;
}
