from unittest.mock import Mock

from genai_platform.use_cases.policy_qa.schemas import PolicyQuestionRequest
from genai_platform.use_cases.policy_qa.service import PolicyQAService


def test_policy_qa_returns_grounded_answer_and_sources():
    knowledge_base = Mock()
    knowledge_base.retrieve.return_value = [
        {
            "text": "Two missed payments require manual review.",
            "score": 0.95,
            "location": {
                "type": "S3",
                "s3Location": {"uri": "s3://example/policy.txt"},
            },
        }
    ]

    bedrock = Mock()
    bedrock.converse.return_value = {
        "output": {"message": {"content": [{"text": "Manual review is required [1]."}]}}
    }

    service = PolicyQAService(
        knowledge_base_service=knowledge_base,
        bedrock_service=bedrock,
        knowledge_base_id="TESTKB123",
        model_id="apac.amazon.nova-micro-v1:0",
    )

    result = service.answer(
        PolicyQuestionRequest(question="What happens after two missed payments?")
    )

    assert result.answer == "Manual review is required [1]."
    assert len(result.sources) == 1
    assert result.sources[0].reference == 1


def test_policy_qa_handles_empty_retrieval():
    knowledge_base = Mock()
    knowledge_base.retrieve.return_value = []

    bedrock = Mock()

    service = PolicyQAService(
        knowledge_base_service=knowledge_base,
        bedrock_service=bedrock,
        knowledge_base_id="TESTKB123",
        model_id="apac.amazon.nova-micro-v1:0",
    )

    result = service.answer(PolicyQuestionRequest(question="What is the policy?"))

    assert result.sources == []
    assert "could not find" in result.answer.lower()
    bedrock.converse.assert_not_called()
