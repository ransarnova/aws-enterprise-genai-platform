"""Tests for the application summary API."""

from unittest.mock import MagicMock

from fastapi.testclient import TestClient

from genai_platform.api.dependencies import get_application_summary_service
from genai_platform.main import create_app
from genai_platform.use_cases.application_summary.schemas import (
    ApplicationSummaryResponse,
)


def test_generate_application_summary_endpoint() -> None:
    """Verify the application summary endpoint without calling AWS."""

    mock_service = MagicMock()
    mock_service.generate.return_value = ApplicationSummaryResponse(
        summary="Applicant has stable income and no missed payments."
    )

    application = create_app()

    application.dependency_overrides[get_application_summary_service] = lambda: mock_service

    client = TestClient(application)

    payload = {
        "monthly_income": 100000,
        "monthly_debt": 20000,
        "missed_payments": 0,
        "requested_loan_amount": 500000,
        "credit_score": 750,
    }

    response = client.post(
        "/api/v1/application-summary",
        json=payload,
    )

    assert response.status_code == 200
    assert response.json() == {"summary": "Applicant has stable income and no missed payments."}

    mock_service.generate.assert_called_once()

    application.dependency_overrides.clear()


def test_application_summary_rejects_invalid_input() -> None:
    """Verify invalid application data returns HTTP 422."""

    mock_service = MagicMock()

    application = create_app()

    application.dependency_overrides[get_application_summary_service] = lambda: mock_service

    client = TestClient(application)

    payload = {
        "monthly_income": -1000,
        "monthly_debt": 20000,
        "missed_payments": 0,
        "requested_loan_amount": 500000,
        "credit_score": 750,
    }

    response = client.post(
        "/api/v1/application-summary",
        json=payload,
    )

    assert response.status_code == 422

    mock_service.generate.assert_not_called()

    application.dependency_overrides.clear()


def test_application_summary_returns_503_when_model_not_configured() -> None:
    """Return HTTP 503 when the Bedrock model is not configured."""

    from genai_platform.core.config import Settings, get_settings

    test_settings = Settings(
        bedrock_model_id=None,
        _env_file=None,
    )

    application = create_app()

    application.dependency_overrides[get_settings] = lambda: test_settings

    client = TestClient(application)

    payload = {
        "monthly_income": 100000,
        "monthly_debt": 20000,
        "missed_payments": 0,
        "requested_loan_amount": 500000,
        "credit_score": 750,
    }

    response = client.post(
        "/api/v1/application-summary",
        json=payload,
    )

    assert response.status_code == 503
    assert response.json() == {"detail": "Bedrock model is not configured."}

    application.dependency_overrides.clear()
