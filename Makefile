ifneq (,$(wildcard ./.env))
  include .env
  export
endif

DOCKER_COMPOSE := $(shell \
  command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1 \
  && echo "docker compose" \
  || { command -v docker-compose >/dev/null 2>&1 && echo "docker-compose"; } \
  || echo "")

ifeq ($(DOCKER_COMPOSE),)
$(error Neither 'docker-compose' nor 'docker compose' is available. Install Docker Compose v2+.)
endif

.PHONY: initEnv build up down ps logs shell-app shell-ui

SVC ?=

# ── 세팅 ────────────────────────────────────────────────────────

initEnv:
	cp .env.sample .env
	@echo ".env created. Edit values before running 'make up'."

# ── 빌드 ────────────────────────────────────────────────────────

build:
	$(DOCKER_COMPOSE) build

# ── 실행 ────────────────────────────────────────────────────────

up:
	$(DOCKER_COMPOSE) up -d

down:
	$(DOCKER_COMPOSE) down

# ── 모니터링 ─────────────────────────────────────────────────────

ps:
	$(DOCKER_COMPOSE) ps -a

# 예) make logs
# 예) make logs SVC=pu-app
# 예) make logs SVC="pu-app pu-ui"
logs:
	$(DOCKER_COMPOSE) logs -f $(SVC)

# ── 접속 ────────────────────────────────────────────────────────

shell-app:
	$(DOCKER_COMPOSE) exec pu-app /bin/sh

shell-ui:
	$(DOCKER_COMPOSE) exec pu-ui /bin/sh
