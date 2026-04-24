# ── Stage 1: Builder ──────────────────────────────────────────
FROM node:22-alpine AS builder

WORKDIR /app

# 의존성 파일만 먼저 복사 → 소스 변경 시 캐시 재사용
COPY package.json package-lock.json* ./
RUN npm ci

# 전체 소스 복사 후 빌드 (output: standalone)
COPY . .
RUN npm run build

# ── Stage 2: Runtime ──────────────────────────────────────────
FROM node:22-alpine AS runtime

WORKDIR /app

# non-root 유저 생성
RUN addgroup -S appgroup && adduser -S appuser -G appgroup -u 1001

# standalone 빌드 결과물만 복사 (node_modules, 소스 제외)
COPY --from=builder --chown=appuser:appgroup /app/.next/standalone ./
COPY --from=builder --chown=appuser:appgroup /app/.next/static ./.next/static
COPY --from=builder --chown=appuser:appgroup /app/public ./public

USER appuser

EXPOSE 3000

ENV NODE_ENV=production \
    PORT=3000 \
    HOSTNAME=0.0.0.0

CMD ["node", "server.js"]
