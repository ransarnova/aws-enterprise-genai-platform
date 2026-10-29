
"use client";

import { useState, type FormEvent } from "react";

type ApplicationSummaryResponse = {
    summary: string;
};

export default function ApplicationSummaryForm() {
    const [monthlyIncome, setMonthlyIncome] = useState("85000");
    const [monthlyDebt, setMonthlyDebt] = useState("15000");
    const [missedPayments, setMissedPayments] = useState("0");
    const [loanAmount, setLoanAmount] = useState("500000");
    const [creditScore, setCreditScore] = useState("750");

    const [summary, setSummary] = useState("");
    const [error, setError] = useState("");
    const [loading, setLoading] = useState(false);

    async function handleSubmit(event: FormEvent<HTMLFormElement>) {
        event.preventDefault();

        setError("");
        setSummary("");

        const income = Number(monthlyIncome);
        const debt = Number(monthlyDebt);
        const missed = Number(missedPayments);
        const amount = Number(loanAmount);
        const score =
            creditScore.trim() === "" ? null : Number(creditScore);

        if (
            !Number.isFinite(income) ||
            income <= 0 ||
            !Number.isFinite(debt) ||
            debt < 0 ||
            !Number.isInteger(missed) ||
            missed < 0 ||
            !Number.isFinite(amount) ||
            amount <= 0 ||
            (score !== null &&
                (!Number.isInteger(score) || score < 300 || score > 900))
        ) {
            setError("Please enter valid application details.");
            return;
        }

        setLoading(true);

        try {
            const response = await fetch("/api/application-summary", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({
                    monthly_income: income,
                    monthly_debt: debt,
                    missed_payments: missed,
                    requested_loan_amount: amount,
                    credit_score: score,
                }),
            });

            if (!response.ok) {
                if (response.status === 401) {
                    throw new Error(
                        "Your session has expired or you are not authorized. Please sign in again."
                    );
                }

                throw new Error(
                    `Application Summary request failed (HTTP ${response.status}).`
                );
            }

            const data: ApplicationSummaryResponse =
                await response.json();

            if (typeof data.summary !== "string") {
                throw new Error("Unexpected response from the backend.");
            }

            setSummary(data.summary);
        } catch (err) {
            setError(
                err instanceof Error
                    ? err.message
                    : "Unable to generate the summary."
            );
        } finally {
            setLoading(false);
        }
    }

    return (
        <section className="mt-8 max-w-2xl rounded-xl border border-gray-200 p-6">
            <h2 className="text-xl font-semibold">
                Lending Application Summary
            </h2>

            <p className="mt-2 text-sm text-gray-600">
                Generate an AI-powered summary of a lending application.
                Use synthetic test data for this prototype.
            </p>

            <form onSubmit={handleSubmit} className="mt-6 space-y-4">
                <div>
                    <label htmlFor="monthly-income" className="block text-sm font-medium">
                        Monthly Income
                    </label>
                    <input
                        id="monthly-income"
                        type="number"
                        min="0.01"
                        step="any"
                        required
                        value={monthlyIncome}
                        onChange={(e) => setMonthlyIncome(e.target.value)}
                        className="mt-1 w-full rounded-lg border p-2"
                    />
                </div>

                <div>
                    <label htmlFor="monthly-debt" className="block text-sm font-medium">
                        Monthly Debt
                    </label>
                    <input
                        id="monthly-debt"
                        type="number"
                        min="0"
                        step="any"
                        required
                        value={monthlyDebt}
                        onChange={(e) => setMonthlyDebt(e.target.value)}
                        className="mt-1 w-full rounded-lg border p-2"
                    />
                </div>

                <div>
                    <label htmlFor="missed-payments" className="block text-sm font-medium">
                        Missed Payments
                    </label>
                    <input
                        id="missed-payments"
                        type="number"
                        min="0"
                        step="1"
                        required
                        value={missedPayments}
                        onChange={(e) => setMissedPayments(e.target.value)}
                        className="mt-1 w-full rounded-lg border p-2"
                    />
                </div>

                <div>
                    <label htmlFor="loan-amount" className="block text-sm font-medium">
                        Requested Loan Amount
                    </label>
                    <input
                        id="loan-amount"
                        type="number"
                        min="0.01"
                        step="any"
                        required
                        value={loanAmount}
                        onChange={(e) => setLoanAmount(e.target.value)}
                        className="mt-1 w-full rounded-lg border p-2"
                    />
                </div>

                <div>
                    <label htmlFor="credit-score" className="block text-sm font-medium">
                        Credit Score (optional)
                    </label>
                    <input
                        id="credit-score"
                        type="number"
                        min="300"
                        max="900"
                        step="1"
                        value={creditScore}
                        onChange={(e) => setCreditScore(e.target.value)}
                        className="mt-1 w-full rounded-lg border p-2"
                    />
                </div>

                <button
                    type="submit"
                    disabled={loading}
                    className="rounded-lg bg-blue-600 px-5 py-2 text-white hover:bg-blue-700 disabled:opacity-50"
                >
                    {loading ? "Generating..." : "Generate Summary"}
                </button>
            </form>

            {error && (
                <p role="alert" className="mt-5 text-sm text-red-600">
                    {error}
                </p>
            )}

            {summary && (
                <div className="mt-6 rounded-lg border border-gray-200 bg-gray-50 p-4 text-gray-900">
                    <h3 className="font-semibold">Generated Summary</h3>
                    <p className="mt-3 whitespace-pre-wrap">{summary}</p>
                </div>
            )}
        </section>
    );
}
