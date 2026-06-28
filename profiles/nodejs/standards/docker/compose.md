# docker-compose — Node.js Backend

Source: docs.docker.com (official Docker docs)

## Single backend + database

```yaml
# docker-compose.yml
services:
  api:
    build:
      context: .
      target: production       # use the production stage from multi-stage build
    ports:
      - "3000:3000"
    environment:
      NODE_ENV: production
      DATABASE_URL: postgresql://postgres:postgres@db:5432/appdb
    depends_on:
      db:
        condition: service_healthy
    restart: unless-stopped

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: appdb
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped

volumes:
  postgres_data:
```

## Development override

```yaml
# docker-compose.override.yml (auto-loaded in dev, not in prod)
services:
  api:
    build:
      target: builder          # use build stage with dev deps
    command: npm run dev
    volumes:
      - ./src:/app/src         # hot-reload: mount source
    environment:
      NODE_ENV: development
    ports:
      - "9229:9229"            # Node.js debugger port

  db:
    ports:
      - "5432:5432"            # expose DB port locally for tools
```

## Rules
- Use `target:` to select the correct build stage per environment
- Use `depends_on: condition: service_healthy` — never just `depends_on: [db]`
- Store credentials in `.env` file (gitignored), reference with `${VAR}` in compose
- Named volumes for persistence; never anonymous volumes
- `restart: unless-stopped` for production services
- Keep `docker-compose.override.yml` for dev extras — it's auto-merged with the base file
