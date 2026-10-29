"""Reusable Amazon Bedrock Knowledge Base retrieval service."""

from typing import Any

import boto3
from botocore.client import BaseClient


class KnowledgeBaseService:
    """Retrieve relevant passages from a Bedrock Knowledge Base."""

    def __init__(self, client: BaseClient) -> None:
        self.client = client

    def retrieve(
        self,
        knowledge_base_id: str,
        query: str,
        number_of_results: int = 5,
    ) -> list[dict[str, Any]]:
        """Return retrieved passages and their source metadata."""

        response = self.client.retrieve(
            knowledgeBaseId=knowledge_base_id,
            retrievalQuery={"text": query},
            retrievalConfiguration={
                "vectorSearchConfiguration": {
                    "numberOfResults": number_of_results,
                }
            },
        )

        results = []

        for item in response.get("retrievalResults", []):
            content = item.get("content", {})
            text = content.get("text")

            if not text:
                continue

            results.append(
                {
                    "text": text,
                    "score": item.get("score"),
                    "location": item.get("location", {}),
                    "metadata": item.get("metadata", {}),
                }
            )

        return results


def create_knowledge_base_service(region: str) -> KnowledgeBaseService:
    """Create a Bedrock Agent Runtime retrieval client."""

    client = boto3.client(
        "bedrock-agent-runtime",
        region_name=region,
    )

    return KnowledgeBaseService(client=client)
