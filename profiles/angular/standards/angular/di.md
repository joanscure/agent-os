# Angular Dependency Injection

Source: angular.dev/style-guide (official Angular team)

## inject() over constructor injection
```ts
// ✅ Preferred
export class UserComponent {
  private userService = inject(UserService);
  private router = inject(Router);
}

// ❌ Avoid (still valid but verbose)
constructor(private userService: UserService, private router: Router) {}
```

## Service Scope
- `providedIn: 'root'` for app-wide singletons (most services)
- Component-level providers only when the service must be scoped to a component tree
- Never provide the same service in both root and a module — creates duplicate instances

## Injection Tokens
- Use `InjectionToken` for non-class dependencies (config, strings, primitive values)
```ts
const API_URL = new InjectionToken<string>('API_URL');
// provide in app.config.ts
{ provide: API_URL, useValue: environment.apiUrl }
// inject
private apiUrl = inject(API_URL);
```

## HTTP Interceptors
- Use `withInterceptors([myInterceptor])` functional style in Angular 17+
- One interceptor per concern (auth headers, error handling, loading state)
