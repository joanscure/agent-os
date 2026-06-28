# React Components

Source: Airbnb React Style Guide + React official docs

## File & Naming
- One component per file; filename matches component name in PascalCase
- Use `.tsx` for components, `.ts` for utilities
- Directory components: `ComponentName/index.tsx`
- Co-locate styles, tests, and helpers in the same folder

## Structure (top to bottom in file)
1. Imports
2. Types/interfaces
3. Constants outside component
4. Component function (PascalCase)
5. Hooks at the top of the function body
6. Derived state / computed values
7. Event handlers (`handleXxx` naming)
8. Return JSX

## Rules
- Always functional components; never class components
- Never use `React.FC` — type props directly: `function Foo({ bar }: FooProps)`
- Use `export default` for page components; named exports for shared components
- Do not spread unknown props onto DOM elements
- Omit `true` for boolean props: `<Input disabled />` not `<Input disabled={true} />`
- Use `key` with stable IDs, never array index on dynamic lists

## JSX
- Use double quotes for JSX attributes, single quotes in JS
- Self-close tags with no children: `<Input />`
- Wrap multi-line JSX in parentheses
