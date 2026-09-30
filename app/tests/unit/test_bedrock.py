"""Unit tests for the Bedrock service."""

from unittest.mock import MagicMock

from genai_platform.services.bedrock import BedrockService


def test_bedrock_converse() -> None:
    """Verify the Converse request without calling AWS."""

    mock_client = MagicMock()

    expected_response = {
        "output": {
            "message": {
                "role": "assistant",
                "content": [{"text": "Hello from Bedrock"}],
            }
        }
    }

    mock_client.converse.return_value = expected_response

    service = BedrockService(client=mock_client)

    messages = [
        {
            "role": "user",
            "content": [{"text": "Hello"}],
        }
    ]

    response = service.converse(
        model_id="test-model",
        messages=messages,
    )

    assert response == expected_response

    mock_client.converse.assert_called_once_with(
        modelId="test-model",
        messages=messages,
        inferenceConfig={
            "maxTokens": 1000,
            "temperature": 0.3,
        },
    )
