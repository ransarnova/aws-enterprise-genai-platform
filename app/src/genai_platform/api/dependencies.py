"""Shared FastAPI dependencies."""

from typing import Annotated

from fastapi import Depends, HTTPException, status

from genai_platform.core.config import Settings, get_settings
from genai_platform.services.bedrock import create_bedrock_service
from genai_platform.use_cases.application_summary.service import (
    ApplicationSummaryService,
)

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
