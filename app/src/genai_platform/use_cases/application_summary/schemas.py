"""Schemas for the application summary use case."""

from pydantic import BaseModel, Field


class ApplicationSummaryRequest(BaseModel):
    """Input data used to generate a lending application summary."""

    monthly_income: float = Field(gt=0)
    monthly_debt: float = Field(ge=0)
    missed_payments: int = Field(ge=0)
    requested_loan_amount: float = Field(gt=0)
    credit_score: int | None = Field(default=None, ge=300, le=900)


class ApplicationSummaryResponse(BaseModel):
    """Generated summary returned by the application."""

    summary: str
