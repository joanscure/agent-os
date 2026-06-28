# docker-compose — Angular + NestJS (full-stack)

Source: docs.docker.com (official Docker docs)

## Full-stack setup

```yaml
# docker-compose.yml
services:
  frontend:
    build:
      context: ./frontend
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
    command: npm run start
    volumes:
      - ./frontend/src:/app/src
    ports:
      - "4200:4200"            # Angular CLI dev server

  api:
    build:
      target: builder
    command: npm run start:dev
    volumes:
      - ./backend/src:/app/src
    environment:
      NODE_ENV: development
    ports:
      - "9229:9229"            # debugger

  db:
    ports:
      - "5432:5432"
```

## nginx API proxy for Angular frontend

Add to `nginx.conf` to proxy `/api` to NestJS — avoids CORS in production:

```nginx
location /api/ {
    proxy_pass http://api:3000/api/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}
```

## NestJS Dockerfile note
NestJS uses the same Node.js multi-stage pattern as the `nodejs` profile.
The `nestjs` profile inherits those Docker standards automatically.
