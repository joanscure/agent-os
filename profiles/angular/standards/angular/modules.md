# Angular Modules & Project Structure

Source: angular.dev/style-guide (official Angular team)

## Preferred Structure (Angular 17+ standalone)
```
src/
  app/
    features/
      users/
        user-list/
          user-list.component.ts
          user-list.component.html
          user-list.component.scss
          user-list.component.spec.ts
        user-detail/
          ...
        services/
          user.service.ts
        models/
          user.model.ts
      dashboard/
        ...
    shared/
      components/      # reusable UI components
      pipes/
      directives/
    core/
      guards/
      interceptors/
      services/        # app-wide singleton services
    app.routes.ts
    app.config.ts
    app.component.ts
```

## Rules
- Organize by feature, not by type (`/components`, `/services`)
- `core/` for app-wide singletons; never import CoreModule in feature modules
- `shared/` for purely presentational/utility components with no side effects
- Co-locate related files (component + template + styles + spec in same folder)
- Lazy-load feature routes: `loadComponent` or `loadChildren`
- One feature = one folder; don't scatter related files across the tree

## Lazy Loading
```ts
// app.routes.ts
{
  path: 'users',
  loadComponent: () => import('./features/users/user-list/user-list.component').then(m => m.UserListComponent)
}
```
