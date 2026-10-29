import { NextResponse } from "next/server";
import { randomBytes, createHash } from "node:crypto";

function base64url(buffer: Buffer): string {
    return buffer.toString("base64url");
}

export async function GET() {
    const domain = process.env.COGNITO_DOMAIN!;
    const clientId = process.env.COGNITO_CLIENT_ID!;
    const appUrl = process.env.APP_URL!;

    const state = base64url(randomBytes(32));
    const codeVerifier = base64url(randomBytes(32));

    const codeChallenge = base64url(
        createHash("sha256").update(codeVerifier).digest()
    );

    if (!domain) {
        throw new Error("COGNITO_DOMAIN is missing");
    }

    const authorizeUrl = new URL(
        "/oauth2/authorize",
        new URL(domain)
    );

    authorizeUrl.searchParams.set("response_type", "code");
    authorizeUrl.searchParams.set("client_id", clientId);
    authorizeUrl.searchParams.set(
        "redirect_uri",
        `${appUrl}/auth/callback`
    );
    authorizeUrl.searchParams.set(
        "scope",
        "openid email genai/application-summary genai/policy-qa"
    );
    authorizeUrl.searchParams.set("state", state);
    authorizeUrl.searchParams.set(
        "code_challenge_method",
        "S256"
    );
    authorizeUrl.searchParams.set("code_challenge", codeChallenge);

    const response = NextResponse.redirect(authorizeUrl);

    const cookieOptions = {
        httpOnly: true,
        secure: process.env.NODE_ENV === "production",
        sameSite: "lax" as const,
        path: "/",
        maxAge: 600,
    };

    response.cookies.set("oauth_state", state, cookieOptions);
    response.cookies.set("pkce_verifier", codeVerifier, cookieOptions);

    return response;
}
