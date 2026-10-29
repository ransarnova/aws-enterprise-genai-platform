import { getIronSession, type SessionOptions } from "iron-session";
import { cookies } from "next/headers";

export interface UserSession {
    accessToken?: string;
    expiresAt?: number;
    isLoggedIn?: boolean;
}

const sessionOptions: SessionOptions = {
    password: process.env.SESSION_SECRET!,
    cookieName: "enterprise_genai_session",
    cookieOptions: {
        httpOnly: true,
        secure: process.env.NODE_ENV === "production",
        sameSite: "lax",
        path: "/",
    },
};

export async function getSession() {
    return getIronSession<UserSession>(
        await cookies(),
        sessionOptions
    );
}

export async function getAuthenticatedSession() {
    const session = await getSession();

    const isValid =
        session.isLoggedIn === true &&
        Boolean(session.accessToken) &&
        typeof session.expiresAt === "number" &&
        Date.now() < session.expiresAt;

    return isValid ? session : null;
}
