# ── Stage 1: Builder ──────────────────────────────────────────
FROM python:3.14-slim AS builder

# uv를 공식 이미지에서 복사 (pip install 불필요)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

WORKDIR /app

ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy

# 의존성 파일만 먼저 복사 → 소스 변경 시 캐시 재사용
COPY pyproject.toml ./
RUN uv sync --no-cache --no-dev --no-install-project

# ── Stage 2: Runtime ──────────────────────────────────────────
FROM python:3.14-slim AS runtime

# healthcheck용 curl 설치
RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

# non-root 유저 생성
RUN groupadd -r appuser && useradd -r -g appuser -u 1000 appuser

WORKDIR /app

# builder에서 가상환경만 복사 (빌드 도구 제외)
COPY --from=builder --chown=appuser:appuser /app/.venv /app/.venv

# 애플리케이션 소스 복사
COPY --chown=appuser:appuser app/ ./app/

ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

USER appuser

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
