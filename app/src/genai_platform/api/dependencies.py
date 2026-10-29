"""Shared FastAPI dependencies."""

from typing import Annotated

from fastapi import Depends, HTTPException, status

from genai_platform.core.config import Settings, get_settings
from genai_platform.services.bedrock import create_bedrock_service
from genai_platform.services.knowledge_base import (
    create_knowledge_base_service,
)
from genai_platform.use_cases.application_summary.service import (
    ApplicationSummaryService,
)
from genai_platform.use_cases.policy_qa.service import PolicyQAService

SettingsDependency = Annotated[Settings, Depends(get_settings)]


def get_application_summary_service(
    settings: SettingsDependency,
) -> ApplicationSummaryService:
    """Create the application summary service."""

    if not settings.bedrock_model_id:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Bedrock model is not configured.",
        )

    bedrock_service = create_bedrock_service(
        region=settings.aws_region,
    )

    return ApplicationSummaryService(
        bedrock_service=bedrock_service,
        model_id=settings.bedrock_model_id,
    )


ApplicationSummaryServiceDependency = Annotated[
    ApplicationSummaryService,
    Depends(get_application_summary_service),
]


def get_policy_qa_service(
    settings: SettingsDependency,
) -> PolicyQAService:
    """Construct the lending policy Q&A service."""

    if not settings.bedrock_model_id:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Bedrock model is not configured.",
        )

    if not settings.bedrock_knowledge_base_id:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Bedrock Knowledge Base is not configured.",
        )

    return PolicyQAService(
        knowledge_base_service=create_knowledge_base_service(
            region=settings.aws_region,
        ),
        bedrock_service=create_bedrock_service(
            region=settings.aws_region,
        ),
        knowledge_base_id=settings.bedrock_knowledge_base_id,
        model_id=settings.bedrock_model_id,
    )


PolicyQAServiceDependency = Annotated[
    PolicyQAService,
    Depends(get_policy_qa_service),
]
