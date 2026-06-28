# Dockerfile — Node.js Backend

Source: docs.docker.com/build/building/best-practices (official Docker docs)

## Multi-stage build (always use this pattern)

```dockerfile
# ── Stage 1: build ──────────────────────────────────────────
FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY tsconfig*.json ./
COPY src ./src
RUN npm run build

# ── Stage 2: production ─────────────────────────────────────
FROM node:20-alpine AS production
WORKDIR /app

# Non-root user (security — never run as root in production)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY package*.json ./

USER appuser

ENV NODE_ENV=production
EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node", "dist/server.js"]
```

## Rules
- Always use **multi-stage builds** — never ship build tools or dev dependencies to production
- Base image: `node:20-alpine` (small, maintained, secure) — pin major version
- Copy `package*.json` BEFORE source code — Docker caches the `npm ci` layer until deps change
- Use `npm ci` not `npm install` — deterministic, fails on lockfile mismatch
- Never run as `root` — create and use a non-root user
- Add `HEALTHCHECK` so orchestrators know when the container is ready
- `EXPOSE` the port for documentation; actual binding is in docker-compose

## .dockerignore (required — place at project root)
```
node_modules
dist
.env*
*.log
coverage
.git
README.md
docker-compose*.yml
```
