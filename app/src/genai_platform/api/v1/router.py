"""Version 1 API route registration."""

from fastapi import APIRouter

from genai_platform.api.v1 import health

api_router = APIRouter(prefix="/api/v1")

api_router.include_router(health.router)
