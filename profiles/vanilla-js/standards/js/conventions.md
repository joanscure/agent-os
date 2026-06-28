# Vanilla JavaScript Conventions

Source: MDN Web Docs + Airbnb JavaScript Style Guide

## Language
- Use ES2022+ features: optional chaining (`?.`), nullish coalescing (`??`), `Array.at()`, `Object.hasOwn()`
- Always use `const` by default; `let` only when reassignment is needed; never `var`
- Use arrow functions for callbacks; named function declarations for top-level functions
- Use template literals instead of string concatenation

## Modules
- Always use ES Modules (`import`/`export`), not CommonJS
- One concept per file; name files after what they export
- Avoid barrel `index.js` files unless necessary for a public API

## Async
- Use `async/await` over raw Promises and never callbacks
- Always handle errors with try/catch on async functions
- Never use `Promise.all` without handling individual rejections when partial failure matters

## DOM
- Cache DOM references — never query the same element twice in a loop
- Use `addEventListener` with named functions (allows removal); never inline `onclick`
- Use `data-*` attributes for JS hooks; never use CSS class names as JS selectors
- Prefer `classList.add/remove/toggle` over `className` string manipulation

## Naming
- camelCase for variables and functions: `getUserData`
- PascalCase for classes: `UserManager`
- UPPER_SNAKE_CASE for module-level constants: `MAX_RETRIES`
- Prefix boolean variables with `is`, `has`, `can`: `isLoading`, `hasError`

## Code quality
- Max function length: ~20 lines — extract if longer
- No magic numbers; extract to named constants
- Avoid deep nesting (max 3 levels); use early returns
