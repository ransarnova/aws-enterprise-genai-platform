"""Tests for the application health endpoint."""

from fastapi.testclient import TestClient

from genai_platform.main import create_app


def test_health_endpoint() -> None:
    """The versioned health endpoint should return HTTP 200."""

    client = TestClient(create_app())

    response = client.get("/api/v1/health")

    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}


def test_legacy_health_endpoint_not_found() -> None:
    """The previous unversioned endpoint should no longer exist."""

    client = TestClient(create_app())

    response = client.get("/health")

    assert response.status_code == 404
