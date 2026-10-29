from unittest.mock import Mock

from genai_platform.services.knowledge_base import KnowledgeBaseService


def test_retrieve_returns_passages_with_sources():
    client = Mock()
    client.retrieve.return_value = {
        "retrievalResults": [
            {
                "content": {"text": "Applications with missed payments require manual review."},
                "score": 0.92,
                "location": {
                    "type": "S3",
                    "s3Location": {"uri": "s3://example-policy/policy.txt"},
                },
                "metadata": {"document_type": "lending_policy"},
            }
        ]
    }

    service = KnowledgeBaseService(client)

    results = service.retrieve(
        knowledge_base_id="TESTKB123",
        query="When is manual review required?",
    )

    assert len(results) == 1
    assert results[0]["score"] == 0.92
    assert results[0]["location"]["type"] == "S3"

    client.retrieve.assert_called_once_with(
        knowledgeBaseId="TESTKB123",
        retrievalQuery={"text": "When is manual review required?"},
        retrievalConfiguration={"vectorSearchConfiguration": {"numberOfResults": 5}},
    )
