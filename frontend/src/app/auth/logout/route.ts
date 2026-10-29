import { NextResponse } from "next/server";
import { getSession } from "@/lib/session";

export async function POST() {
    const appUrl = process.env.APP_URL!;
    const domain = process.env.COGNITO_DOMAIN!;
    const clientId = process.env.COGNITO_CLIENT_ID!;

    // Destroy the encrypted application session.
    const session = await getSession();
    session.destroy();

    // Redirect through Cognito's logout endpoint.
    const logoutUrl = new URL("/logout", domain);

    logoutUrl.searchParams.set("client_id", clientId);
    logoutUrl.searchParams.set("logout_uri", `${appUrl}/`);

    return NextResponse.redirect(logoutUrl, 303);
}
