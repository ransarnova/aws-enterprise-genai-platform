"""Unit tests for the application summary use case."""

from unittest.mock import MagicMock

import pytest
from pydantic import ValidationError

from genai_platform.use_cases.application_summary.schemas import (
    ApplicationSummaryRequest,
)
from genai_platform.use_cases.application_summary.service import (
    ApplicationSummaryService,
)


def test_invalid_credit_score_is_rejected() -> None:
    """Reject credit scores outside the accepted range."""

    with pytest.raises(ValidationError):
        ApplicationSummaryRequest(
            monthly_income=100000,
            monthly_debt=20000,
            missed_payments=0,
            requested_loan_amount=500000,
            credit_score=1000,
        )


def test_generate_application_summary() -> None:
    """Verify summary generation using a mocked Bedrock service."""

    mock_bedrock_service = MagicMock()

    mock_bedrock_service.converse.return_value = {
        "output": {
            "message": {
                "role": "assistant",
                "content": [
                    {
                        "text": (
                            "Applicant reports monthly income of 100000 and monthly debt of 20000."
                        )
                    }
                ],
            }
        }
    }

    service = ApplicationSummaryService(
        bedrock_service=mock_bedrock_service,
        model_id="test-model",
    )

    request = ApplicationSummaryRequest(
        monthly_income=100000,
        monthly_debt=20000,
        missed_payments=0,
        requested_loan_amount=500000,
        credit_score=750,
    )

    response = service.generate(request)

    assert response.summary == (
        "Applicant reports monthly income of 100000 and monthly debt of 20000."
    )

    mock_bedrock_service.converse.assert_called_once()

    call = mock_bedrock_service.converse.call_args

    assert call.kwargs["model_id"] == "test-model"
    assert call.kwargs["max_tokens"] == 500
    assert call.kwargs["temperature"] == 0.2

    prompt = call.kwargs["messages"][0]["content"][0]["text"]

    assert "Monthly income: 100000.0" in prompt
    assert "Monthly debt: 20000.0" in prompt
    assert "Missed payments: 0" in prompt
    assert "Requested loan amount: 500000.0" in prompt
    assert "Credit score: 750" in prompt
