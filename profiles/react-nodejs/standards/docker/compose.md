# docker-compose — React + Node.js (full-stack)

Source: docs.docker.com (official Docker docs)

## Full-stack setup

```yaml
# docker-compose.yml
services:
  frontend:
    build:
      context: ./frontend      # or . if monorepo with separate Dockerfiles
      target: production
    ports:
      - "80:80"
    depends_on:
      - api
    restart: unless-stopped

  api:
    build:
      context: ./backend
      target: production
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
# docker-compose.override.yml
services:
  frontend:
    build:
      target: builder
    command: npm run dev
    volumes:
      - ./frontend/src:/app/src
    ports:
      - "5173:5173"            # Vite dev server

  api:
    build:
      target: builder
    command: npm run dev
    volumes:
      - ./backend/src:/app/src
    environment:
      NODE_ENV: development
    ports:
      - "9229:9229"

  db:
    ports:
      - "5432:5432"
```

## nginx config for frontend → proxy to API

If you want frontend to proxy `/api` calls to the backend (avoids CORS in production):

```nginx
location /api/ {
    proxy_pass http://api:3000/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}
```
Add this block inside the `server {}` block of your `nginx.conf`.
