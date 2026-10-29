export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center gap-6 p-8">
      <h1 className="text-3xl font-bold">
        Enterprise GenAI Platform
      </h1>

      <p className="text-center text-gray-600">
        Secure AI-powered application summaries and policy Q&A.
      </p>

      <a
        href="/auth/login"
        className="rounded-lg bg-blue-600 px-6 py-3 font-medium text-white hover:bg-blue-700"
      >
        Sign in with Cognito
      </a>
    </main>
  );
}
