import { NextRequest, NextResponse } from "next/server";
import { cookies } from "next/headers";
import { getSession } from "@/lib/session";

export async function GET(request: NextRequest) {
    const appUrl = process.env.APP_URL!;
    const domain = process.env.COGNITO_DOMAIN!;
    const clientId = process.env.COGNITO_CLIENT_ID!;

    const code = request.nextUrl.searchParams.get("code");
    const state = request.nextUrl.searchParams.get("state");

    const cookieStore = await cookies();
    const expectedState = cookieStore.get("oauth_state")?.value;
    const codeVerifier = cookieStore.get("pkce_verifier")?.value;

    if (!code || !state || !expectedState || !codeVerifier ||
        state !== expectedState) {
        return NextResponse.json(
            { error: "Invalid OAuth callback" },
            { status: 400 }
        );
    }

    const tokenResponse = await fetch(
        new URL("/oauth2/token", domain),
        {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
            },
            body: new URLSearchParams({
                grant_type: "authorization_code",
                client_id: clientId,
                code,
                redirect_uri: `${appUrl}/auth/callback`,
                code_verifier: codeVerifier,
            }),
            cache: "no-store",
        }
    );

    if (!tokenResponse.ok) {
        return NextResponse.json(
            { error: "Token exchange failed" },
            { status: 401 }
        );
    }

    const tokens = await tokenResponse.json();

    const session = await getSession();
    session.accessToken = tokens.access_token;
    session.expiresAt = Date.now() + tokens.expires_in * 1000;
    session.isLoggedIn = true;

    await session.save();

    cookieStore.delete("oauth_state");
    cookieStore.delete("pkce_verifier");

    return NextResponse.redirect(new URL("/dashboard", appUrl));
}
