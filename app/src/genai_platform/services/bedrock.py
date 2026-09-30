"""Amazon Bedrock runtime service."""

from typing import Any

import boto3
from botocore.client import BaseClient


class BedrockService:
    """Encapsulate interactions with Amazon Bedrock Runtime."""

    def __init__(self, client: BaseClient) -> None:
        self.client = client

    def converse(
        self,
        model_id: str,
        messages: list[dict[str, Any]],
        max_tokens: int = 1000,
        temperature: float = 0.3,
    ) -> dict[str, Any]:
        """Invoke the Bedrock Converse API."""

        return self.client.converse(
            modelId=model_id,
            messages=messages,
            inferenceConfig={
                "maxTokens": max_tokens,
                "temperature": temperature,
            },
        )


def create_bedrock_service(region: str) -> BedrockService:
    """Create a Bedrock service for the configured AWS region."""

    client = boto3.client(
        "bedrock-runtime",
        region_name=region,
    )

    return BedrockService(client=client)
