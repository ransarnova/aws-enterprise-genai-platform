
import { NextRequest, NextResponse } from "next/server";
import { getAuthenticatedSession } from "@/lib/session";

export async function POST(request: NextRequest) {
    const session = await getAuthenticatedSession();

    if (!session?.accessToken) {
        return NextResponse.json(
            { error: "Unauthorized" },
            { status: 401 }
        );
    }

    const apiBaseUrl = process.env.API_GATEWAY_BASE_URL;

    if (!apiBaseUrl) {
        console.error("API Gateway base URL is not configured");

        return NextResponse.json(
            { error: "Service configuration error" },
            { status: 500 }
        );
    }

    let payload: unknown;

    try {
        payload = await request.json();
    } catch {
        return NextResponse.json(
            { error: "Invalid JSON request" },
            { status: 400 }
        );
    }

    // Validate input before forwarding it to the backend.
    if (
        typeof payload !== "object" ||
        payload === null ||
        !("question" in payload) ||
        typeof payload.question !== "string" ||
        payload.question.length < 3 ||
        payload.question.length > 1000
    ) {
        return NextResponse.json(
            { error: "Question must be between 3 and 1000 characters." },
            { status: 400 }
        );
    }

    try {
        const response = await fetch(
            `${apiBaseUrl.replace(/\/$/, "")}/api/v1/policy-qa`,
            {
                method: "POST",
                headers: {
                    Authorization: `Bearer ${session.accessToken}`,
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({
                    question: payload.question,
                }),
                cache: "no-store",
                signal: AbortSignal.timeout(30000),
            }
        );

        if (!response.ok) {
            console.error("Policy Q&A upstream error:", response.status);

            return NextResponse.json(
                { error: "Policy Q&A request failed" },
                { status: response.status }
            );
        }

        const result = await response.json();

        return NextResponse.json(result);
    } catch (error) {
        console.error("Policy Q&A upstream request failed", error);

        return NextResponse.json(
            { error: "Backend service unavailable" },
            { status: 502 }
        );
    }
}
