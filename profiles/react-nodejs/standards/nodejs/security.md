# Node.js Security

Source: goldbergyoni/nodebestpractices + OWASP

## Input & Validation
- Validate and sanitize ALL incoming request data (body, params, query) with Zod
- Never pass raw user input to database queries — use parameterized queries / ORM
- Escape output in templates to prevent XSS

## Secrets & Config
- Never commit secrets to git — use `.env` + `.gitignore`
- Use environment variables for all secrets (API keys, DB passwords)
- Add `dotenv` validation at startup so missing secrets fail fast

## HTTP Headers
- Use `helmet` middleware: sets CSP, X-Frame-Options, HSTS, etc.
- Disable `X-Powered-By` header (reveals Express)
- Implement rate limiting on public endpoints (`express-rate-limit`)

## Authentication
- Hash passwords with `bcrypt` (min cost factor 10)
- Use short-lived JWTs; implement refresh token rotation
- Never store sensitive data in JWT payload

## Dependencies
- Run `npm audit` in CI; fail build on high/critical vulnerabilities
- Keep dependencies updated; use `npm outdated` regularly
- Avoid packages with no maintenance history

## Process
- Run as non-root user
- Never use `eval()` or `new Function()` with user input
