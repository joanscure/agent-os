# React Hooks

Source: React official docs + community best practices

## Rules
- Call hooks only at the top level — never inside loops, conditions, or nested functions
- Call hooks only from React functions, not plain JS
- Custom hooks must start with `use` prefix
- One concern per custom hook; don't bundle unrelated logic

## useState
- Use separate state variables for unrelated state
- Never mutate state directly; always return new object/array
- Prefer `useReducer` when state transitions are complex or interdependent

## useEffect
- Always declare all dependencies in the array; never suppress the lint rule
- Clean up subscriptions, timers, and event listeners in the return function
- Separate effects by concern — don't combine multiple unrelated side effects
- Prefer derived state or event handlers over effects when possible

## useCallback / useMemo
- Only memoize when referential stability is needed (passed as prop to memoized child or used as effect dep)
- Don't memoize by default; premature optimization adds complexity

## Data Fetching
- Use TanStack Query (React Query) for server state — avoid useEffect for fetches
- Keep server state and UI state separate

## Custom Hooks Pattern
```ts
function useResourceName(params) {
  // state
  // effects
  // handlers
  return { data, isLoading, error, actions }
}
```
