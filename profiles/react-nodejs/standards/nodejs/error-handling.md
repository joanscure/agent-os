# Node.js Error Handling

Source: goldbergyoni/nodebestpractices

## Error Types
- **Operational errors**: expected failures (invalid input, DB down) — handle and recover
- **Programmer errors**: bugs (undefined reference, wrong type) — crash and restart

## Custom Error Class
```ts
class AppError extends Error {
  constructor(
    message: string,
    public readonly code: string,      // e.g. 'USER_NOT_FOUND'
    public readonly statusCode: number, // HTTP status
    public readonly isOperational = true
  ) {
    super(message)
    this.name = this.constructor.name
  }
}
```

## Rules
- Always `await` promises before returning — preserves full stack trace
- Route all errors to a single centralized error handler middleware
- Never swallow errors with empty catch blocks
- Subscribe to `process.on('unhandledRejection')` and `process.on('uncaughtException')` — log then exit
- Validate all incoming data at the route boundary with Zod before it reaches the service

## HTTP Error Responses
```json
{
  "error": {
    "code": "USER_NOT_FOUND",
    "message": "User with id 42 does not exist"
  }
}
```

- Never expose stack traces in production responses
- Log full error server-side; return safe message to client
- Use consistent status codes: 400 (validation), 401 (auth), 403 (forbidden), 404 (not found), 500 (unexpected)
