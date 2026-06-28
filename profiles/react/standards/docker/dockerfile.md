# Dockerfile — React Frontend

Source: docs.docker.com/build/building/best-practices (official Docker docs)

## Multi-stage: build with Node, serve with nginx

```dockerfile
# ── Stage 1: build ──────────────────────────────────────────
FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build              # outputs to /app/dist

# ── Stage 2: serve ──────────────────────────────────────────
FROM nginx:alpine AS production
WORKDIR /usr/share/nginx/html

# Remove default nginx static files
RUN rm -rf ./*

# Copy built assets from builder
COPY --from=builder /app/dist .

# Custom nginx config for SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

## nginx.conf (SPA routing — required for React Router)

```nginx
server {
    listen 80;
    root /usr/share/nginx/html;
    index index.html;

    # Serve static assets with caching
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff2)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # All other routes → index.html (SPA fallback)
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Security headers
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
```

## Rules
- Never serve a React app with Node.js in production — use nginx
- Multi-stage keeps the final image small (nginx:alpine ~23MB vs node:alpine ~180MB)
- Always include the SPA fallback (`try_files ... /index.html`) for client-side routing
- Set long cache headers for hashed assets (`[name].[hash].js`)
