"""Schemas for lending policy question answering."""

from pydantic import BaseModel, Field


class PolicyQuestionRequest(BaseModel):
    question: str = Field(min_length=3, max_length=1000)


class PolicySource(BaseModel):
    reference: int
    location: dict
    score: float | None = None


class PolicyQuestionResponse(BaseModel):
    answer: str
    sources: list[PolicySource]
