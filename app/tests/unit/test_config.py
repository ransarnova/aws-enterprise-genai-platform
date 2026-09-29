"""Tests for centralized application configuration."""

from genai_platform.core.config import Settings, get_settings


def test_default_settings(monkeypatch) -> None:
    """Verify application defaults without external configuration."""

    monkeypatch.delenv("APP_NAME", raising=False)
    monkeypatch.delenv("ENVIRONMENT", raising=False)
    monkeypatch.delenv("AWS_REGION", raising=False)

    settings = Settings(_env_file=None)

    assert settings.app_name == "Enterprise GenAI Platform"
    assert settings.environment == "local"
    assert settings.aws_region == "ap-south-1"


def test_environment_override(monkeypatch) -> None:
    """Verify environment variables override defaults."""

    monkeypatch.setenv("ENVIRONMENT", "test")
    monkeypatch.setenv("AWS_REGION", "us-east-1")

    settings = Settings(_env_file=None)

    assert settings.environment == "test"
    assert settings.aws_region == "us-east-1"


def test_settings_cache() -> None:
    """Verify repeated calls return the cached settings instance."""

    get_settings.cache_clear()

    first = get_settings()
    second = get_settings()

    assert first is second

    get_settings.cache_clear()
