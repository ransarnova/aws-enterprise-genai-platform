"""Tests for the application health endpoint."""

from fastapi.testclient import TestClient

from genai_platform.main import app


def test_health_endpoint() -> None:
    """The health endpoint should return HTTP 200."""

    client = TestClient(app)

    response = client.get("/health")

    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}
