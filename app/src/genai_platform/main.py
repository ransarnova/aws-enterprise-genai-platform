"""Enterprise GenAI Platform API."""

from fastapi import FastAPI

app = FastAPI(
    title="Enterprise GenAI Platform",
    version="0.1.0",
    description="Reusable enterprise GenAI platform reference implementation.",
)


@app.get("/health", tags=["Health"])
def health() -> dict[str, str]:
    """Return the application health status."""
    return {"status": "healthy"}
