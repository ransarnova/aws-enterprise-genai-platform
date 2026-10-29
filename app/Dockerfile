
# syntax=docker/dockerfile:1

FROM python:3.12-slim AS builder

WORKDIR /build

COPY pyproject.toml .
COPY src/ ./src/

RUN python -m pip install --no-cache-dir \
    --prefix=/install \
    .

FROM python:3.12-slim AS runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/usr/local/bin:${PATH}"

WORKDIR /app

COPY --from=builder /install /usr/local

RUN groupadd --system appgroup \
    && useradd --system \
    --gid appgroup \
    --home-dir /app \
    --no-create-home \
    appuser

USER appuser

EXPOSE 8000

CMD ["uvicorn", "genai_platform.main:app", "--host", "0.0.0.0", "--port", "8000"]
