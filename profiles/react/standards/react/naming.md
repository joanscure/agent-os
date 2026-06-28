# React Naming Conventions

Source: Airbnb React Style Guide

## Components
- PascalCase: `UserProfile`, `DashboardCard`
- Higher-order components: `withAuth(Component)`

## Files
- Component files: `UserProfile.tsx`
- Test files: `UserProfile.spec.tsx` or `UserProfile.test.tsx`
- Styles: `UserProfile.module.css`
- Hooks: `useUserProfile.ts`
- Context: `UserContext.tsx`
- Types: `user.types.ts` or inline in component file

## Props & Handlers
- Event handlers: `handleClick`, `handleSubmit`, `handleChange`
- Boolean props: `isLoading`, `hasError`, `isDisabled`
- Callback props: `onSuccess`, `onChange`, `onClose`

## Variables
- camelCase for variables and functions
- UPPER_SNAKE_CASE for module-level constants
- Avoid abbreviations unless universally known (id, url, api)
