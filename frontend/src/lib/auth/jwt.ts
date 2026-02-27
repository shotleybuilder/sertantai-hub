/**
 * Client-side JWT payload decoder
 * No verification — backend handles that. This just extracts claims for UI use.
 */

export interface JwtPayload {
	sub: string;
	email?: string;
	name?: string;
	org_id?: string;
	organization_id?: string;
	role?: string;
	exp: number;
	iat?: number;
	iss?: string;
}

/**
 * Decode the payload (middle segment) of a JWT without verification.
 * Returns null if the token is malformed.
 */
export function decodePayload(token: string): JwtPayload | null {
	try {
		const parts = token.split('.');
		if (parts.length !== 3) return null;

		const payload = parts[1];
		const json = atob(payload.replace(/-/g, '+').replace(/_/g, '/'));
		return JSON.parse(json) as JwtPayload;
	} catch {
		return null;
	}
}

/**
 * Check if a JWT is expired (or within bufferMs of expiry).
 */
export function isExpired(token: string, bufferMs = 0): boolean {
	const payload = decodePayload(token);
	if (!payload?.exp) return true;
	return Date.now() >= payload.exp * 1000 - bufferMs;
}
