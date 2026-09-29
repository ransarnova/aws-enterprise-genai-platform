"""Enterprise GenAI Platform application entry point."""

from fastapi import FastAPI

from genai_platform.api.v1.router import api_router
from genai_platform.core.config import get_settings


def create_app() -> FastAPI:
    """Create and configure the FastAPI application."""

    settings = get_settings()

    application = FastAPI(
        title=settings.app_name,
        version="0.1.0",
        description="Reusable enterprise GenAI platform reference implementation.",
    )

    application.include_router(api_router)

    return application


app = create_app()
