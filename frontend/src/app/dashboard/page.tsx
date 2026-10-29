
import { Suspense } from "react";
import { connection } from "next/server";
import { redirect } from "next/navigation";
import { getAuthenticatedSession } from "@/lib/session";
import ApplicationSummaryForm from "./application-summary-form";
import PolicyQAForm from "./policy-qa-form";

async function AuthenticatedDashboard() {
    // Ensure authentication is evaluated at request time.
    await connection();

    // Validate the encrypted session and access-token expiry.
    const session = await getAuthenticatedSession();

    if (!session) {
        redirect("/");
    }

    return (
        <main className="min-h-screen p-10">
            <h1 className="text-3xl font-bold">
                Enterprise GenAI Dashboard
            </h1>

            <p className="mt-4">
                You have successfully authenticated using Amazon Cognito.
            </p>

            <p className="mt-2 text-gray-600">
                Next: Application Summary and Policy Q&A integration.
            </p>
            <ApplicationSummaryForm />
            <PolicyQAForm />
            <form
                action="/auth/logout"
                method="POST"
                className="mt-6"
            >
                <button
                    type="submit"
                    className="rounded-lg bg-red-600 px-5 py-2 text-white hover:bg-red-700 transition-colors"
                >
                    Logout
                </button>
            </form>
        </main>
    );
}

export default function DashboardPage() {
    return (
        <Suspense
            fallback={
                <main className="min-h-screen p-10">
                    <p>Checking authentication...</p>
                </main>
            }
        >
            <AuthenticatedDashboard />
        </Suspense>
    );
}
