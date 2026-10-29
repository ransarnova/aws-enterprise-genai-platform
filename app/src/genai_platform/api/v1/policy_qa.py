"""Lending policy question-answering API."""

from fastapi import APIRouter

from genai_platform.api.dependencies import PolicyQAServiceDependency
from genai_platform.use_cases.policy_qa.schemas import (
    PolicyQuestionRequest,
    PolicyQuestionResponse,
)

router = APIRouter(tags=["Policy Q&A"])


@router.post(
    "/policy-qa",
    response_model=PolicyQuestionResponse,
)
def answer_policy_question(
    request: PolicyQuestionRequest,
    service: PolicyQAServiceDependency,
) -> PolicyQuestionResponse:
    """Answer a question using retrieved lending policy documents."""
    return service.answer(request)
