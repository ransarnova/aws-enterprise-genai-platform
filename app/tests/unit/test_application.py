"""Tests for FastAPI application initialization."""

from unittest.mock import patch

from fastapi.testclient import TestClient

from genai_platform.core.config import Settings
from genai_platform.main import create_app


def test_application_uses_configured_name() -> None:
    """Verify that application metadata uses centralized settings."""

    test_settings = Settings(
        app_name="Test Platform",
        _env_file=None,
    )

    with patch(
        "genai_platform.main.get_settings",
        return_value=test_settings,
    ):
        application = create_app()

    client = TestClient(application)

    response = client.get("/openapi.json")

    assert response.status_code == 200
    assert response.json()["info"]["title"] == "Test Platform"
