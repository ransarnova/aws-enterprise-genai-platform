"""Application summary API endpoints."""

from fastapi import APIRouter

from genai_platform.api.dependencies import ApplicationSummaryServiceDependency
from genai_platform.use_cases.application_summary.schemas import (
    ApplicationSummaryRequest,
    ApplicationSummaryResponse,
)

router = APIRouter(
    prefix="/application-summary",
    tags=["Application Summary"],
)


@router.post("", response_model=ApplicationSummaryResponse)
def generate_application_summary(
    request: ApplicationSummaryRequest,
    service: ApplicationSummaryServiceDependency,
) -> ApplicationSummaryResponse:
    """Generate a summary of a lending application."""

    return service.generate(request)
