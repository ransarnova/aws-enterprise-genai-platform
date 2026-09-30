"""Application summary generation use case."""

from typing import Any

from genai_platform.services.bedrock import BedrockService
from genai_platform.use_cases.application_summary.schemas import (
    ApplicationSummaryRequest,
    ApplicationSummaryResponse,
)


class ApplicationSummaryService:
    """Generate summaries for lending applications."""

    def __init__(
        self,
        bedrock_service: BedrockService,
        model_id: str,
    ) -> None:
        self.bedrock_service = bedrock_service
        self.model_id = model_id

    def generate(
        self,
        request: ApplicationSummaryRequest,
    ) -> ApplicationSummaryResponse:
        """Generate an application summary using Amazon Bedrock."""

        prompt = self._build_prompt(request)

        messages: list[dict[str, Any]] = [
            {
                "role": "user",
                "content": [{"text": prompt}],
            }
        ]

        response = self.bedrock_service.converse(
            model_id=self.model_id,
            messages=messages,
            max_tokens=500,
            temperature=0.2,
        )

        summary = response["output"]["message"]["content"][0]["text"]

        return ApplicationSummaryResponse(summary=summary)

    @staticmethod
    def _build_prompt(request: ApplicationSummaryRequest) -> str:
        """Build the prompt from validated application data."""

        return (
            "Summarize the following lending application facts. "
            "Do not make an approval or rejection decision.\n\n"
            f"Monthly income: {request.monthly_income}\n"
            f"Monthly debt: {request.monthly_debt}\n"
            f"Missed payments: {request.missed_payments}\n"
            f"Requested loan amount: {request.requested_loan_amount}\n"
            f"Credit score: {request.credit_score}"
        )
