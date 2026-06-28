# Dockerfile — Angular Frontend

Source: docs.docker.com/build/building/best-practices (official Docker docs)

## Multi-stage: build with Node, serve with nginx

```dockerfile
# ── Stage 1: build ──────────────────────────────────────────
FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build              # outputs to /app/dist/<project-name>/browser

# ── Stage 2: serve ──────────────────────────────────────────
FROM nginx:alpine AS production
WORKDIR /usr/share/nginx/html

RUN rm -rf ./*

# Angular 17+ outputs to dist/<project>/browser
COPY --from=builder /app/dist/*/browser .

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

## nginx.conf (SPA routing — required for Angular Router)

```nginx
server {
    listen 80;
    root /usr/share/nginx/html;
    index index.html;

    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff2)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Angular Router fallback
    location / {
        try_files $uri $uri/ /index.html;
    }

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";
    add_header Referrer-Policy "strict-origin-when-cross-origin";
}
```

## .dockerignore
```
node_modules
dist
.env*
*.log
.git
README.md
.angular
```

## Rules
- Angular 17+ build output is `dist/<project-name>/browser/` — adjust COPY path to match
- Check your `angular.json` for the exact `outputPath` if unsure
- Use `--configuration production` in `npm run build` (Angular CLI sets this by default)
- Never serve Angular with Node.js — nginx handles static files orders of magnitude faster
