
"use client";

import { useState, type FormEvent } from "react";

type PolicySource = {
    reference: number;
    location: Record<string, unknown>;
    score: number | null;
};

type PolicyQAResponse = {
    answer: string;
    sources: PolicySource[];
};

export default function PolicyQAForm() {
    const [question, setQuestion] = useState(
        "What factors require enhanced manual review?"
    );

    const [answer, setAnswer] = useState("");
    const [sources, setSources] = useState<PolicySource[]>([]);
    const [error, setError] = useState("");
    const [loading, setLoading] = useState(false);

    async function handleSubmit(event: FormEvent<HTMLFormElement>) {
        event.preventDefault();

        setError("");
        setAnswer("");
        setSources([]);

        const trimmedQuestion = question.trim();

        if (
            trimmedQuestion.length < 3 ||
            trimmedQuestion.length > 1000
        ) {
            setError("Question must be between 3 and 1000 characters.");
            return;
        }

        setLoading(true);

        try {
            const response = await fetch("/api/policy-qa", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({
                    question: trimmedQuestion,
                }),
            });

            if (!response.ok) {
                if (response.status === 401) {
                    throw new Error(
                        "Your session has expired or you are not authorized. Please sign in again."
                    );
                }

                throw new Error(
                    `Policy Q&A request failed (HTTP ${response.status}).`
                );
            }

            const data: PolicyQAResponse = await response.json();

            if (
                typeof data.answer !== "string" ||
                !Array.isArray(data.sources)
            ) {
                throw new Error("Unexpected response from the backend.");
            }

            setAnswer(data.answer);
            setSources(data.sources);
        } catch (err) {
            setError(
                err instanceof Error
                    ? err.message
                    : "Unable to retrieve the policy answer."
            );
        } finally {
            setLoading(false);
        }
    }

    return (
        <section className="mt-8 max-w-2xl rounded-xl border border-gray-200 p-6">
            <h2 className="text-xl font-semibold">
                Lending Policy Q&A
            </h2>

            <p className="mt-2 text-sm text-gray-600">
                Ask questions about the lending policy using our
                Bedrock Knowledge Base and retrieval-augmented generation.
            </p>

            <form onSubmit={handleSubmit} className="mt-6 space-y-4">
                <div>
                    <label
                        htmlFor="policy-question"
                        className="block text-sm font-medium"
                    >
                        Your Question
                    </label>

                    <textarea
                        id="policy-question"
                        rows={4}
                        minLength={3}
                        maxLength={1000}
                        required
                        value={question}
                        onChange={(event) => setQuestion(event.target.value)}
                        className="mt-2 w-full rounded-lg border p-3"
                        placeholder="Ask a question about the lending policy..."
                    />

                    <p className="mt-1 text-xs text-gray-500">
                        {question.length}/1000 characters
                    </p>
                </div>

                <button
                    type="submit"
                    disabled={loading}
                    className="rounded-lg bg-blue-600 px-5 py-2 text-white hover:bg-blue-700 disabled:opacity-50"
                >
                    {loading ? "Retrieving answer..." : "Ask Policy Question"}
                </button>
            </form>

            {error && (
                <p role="alert" className="mt-5 text-sm text-red-600">
                    {error}
                </p>
            )}

            {answer && (
                <div className="mt-6 rounded-lg border border-gray-200 bg-gray-50 p-4 text-gray-900">
                    <h3 className="font-semibold">Policy Answer</h3>
                    <p className="mt-3 whitespace-pre-wrap">{answer}</p>
                </div>
            )}

            {sources.length > 0 && (
                <div className="mt-6 rounded-lg border border-gray-200 p-4">
                    <h3 className="font-semibold">
                        Retrieved Sources ({sources.length})
                    </h3>

                    <ul className="mt-3 space-y-3">
                        {sources.map((source, index) => (
                            <li
                                key={`${source.reference}-${index}`}
                                className="rounded-lg bg-gray-50 p-3 text-sm"
                            >
                                <p className="font-medium">
                                    Reference {source.reference}
                                </p>

                                {typeof source.score === "number" && (
                                    <p className="mt-1 text-gray-600">
                                        Retrieval score: {source.score.toFixed(4)}
                                    </p>
                                )}

                                <details className="mt-2">
                                    <summary className="cursor-pointer text-blue-600">
                                        View source metadata
                                    </summary>

                                    <pre className="mt-2 overflow-x-auto whitespace-pre-wrap break-all text-xs">
                                        {JSON.stringify(source.location, null, 2)}
                                    </pre>
                                </details>
                            </li>
                        ))}
                    </ul>
                </div>
            )}
        </section>
    );
}
