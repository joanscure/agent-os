# Angular Naming Conventions

Source: angular.dev/style-guide (official Angular team)

## Files
- Separate words with hyphens: `user-profile.component.ts`
- Suffix indicates type: `.component.ts`, `.service.ts`, `.module.ts`, `.pipe.ts`, `.directive.ts`, `.guard.ts`, `.resolver.ts`
- Test files: `user-profile.component.spec.ts`
- Group by feature: `user-profile.component.ts` + `user-profile.component.html` + `user-profile.component.scss` in same folder

## Classes
- PascalCase + suffix: `UserProfileComponent`, `UserService`, `UsersModule`, `AuthGuard`

## Selectors
- Components: kebab-case with app prefix: `app-user-profile`
- Attribute directives: camelCase with app prefix: `appHighlight`
- Use a consistent app-wide prefix (not just `app` — pick something meaningful for your project)

## Don'ts
- Never use generic names: `helpers.ts`, `utils.ts`, `common.ts`, `misc.ts`
- Never put the suffix in the selector: `app-user-profile-component` ❌
