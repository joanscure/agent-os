# Node.js Project Structure

Source: goldbergyoni/nodebestpractices (★100k+)

## Directory Layout
```
src/
  users/           # feature folder
    users.router.ts
    users.controller.ts
    users.service.ts
    users.repository.ts
    users.schema.ts
  orders/
    ...
  shared/
    middleware/
    errors/
    config/
  app.ts
  server.ts
```

## Rules
- Organize by feature/domain, not by technical layer
- Each feature folder owns its routes, controller, service, and data layer
- `shared/` only for truly cross-cutting concerns
- Export a clear public interface from each module via `index.ts`
- Keep `app.ts` (Express setup) separate from `server.ts` (HTTP listen) — enables testing without port binding

## Layers (within each feature)
1. **Router** — route definitions, no logic
2. **Controller** — parse request, call service, format response
3. **Service** — all business logic, framework-agnostic
4. **Repository** — all database queries, returns domain objects

## Configuration
- Load from environment variables; validate with Zod at startup
- Never hardcode secrets or environment-specific values
- Fail fast: throw on missing required config at boot time
