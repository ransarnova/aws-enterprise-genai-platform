from unittest.mock import Mock

from fastapi.testclient import TestClient

from genai_platform.api.dependencies import get_policy_qa_service
from genai_platform.main import app
from genai_platform.use_cases.policy_qa.schemas import (
    PolicyQuestionResponse,
    PolicySource,
)


def test_policy_qa_endpoint():
    service = Mock()
    service.answer.return_value = PolicyQuestionResponse(
        answer="Manual review is required [1].",
        sources=[
            PolicySource(
                reference=1,
                location={
                    "type": "S3",
                    "s3Location": {"uri": "s3://example/policy.txt"},
                },
                score=0.95,
            )
        ],
    )

    app.dependency_overrides[get_policy_qa_service] = lambda: service

    try:
        with TestClient(app) as client:
            response = client.post(
                "/api/v1/policy-qa",
                json={"question": "When is manual review required?"},
            )

        assert response.status_code == 200
        assert response.json()["answer"] == ("Manual review is required [1].")
        assert len(response.json()["sources"]) == 1

    finally:
        app.dependency_overrides.clear()
