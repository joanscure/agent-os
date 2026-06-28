# NestJS Modules

Source: docs.nestjs.com (official NestJS docs)

## Structure
```
src/
  users/
    dto/
      create-user.dto.ts
      update-user.dto.ts
    entities/
      user.entity.ts
    users.controller.ts
    users.service.ts
    users.module.ts
  auth/
    guards/
      jwt-auth.guard.ts
    strategies/
      jwt.strategy.ts
    auth.controller.ts
    auth.service.ts
    auth.module.ts
  app.module.ts
  main.ts
```

## Rules
- One module per feature domain; never put multiple unrelated features in one module
- `AppModule` only imports feature modules and global config
- Shared utilities → `SharedModule` (exported for reuse)
- Global singletons (config, DB) → use `isGlobal: true` or register in `AppModule`

## Module Template
```ts
@Module({
  imports: [...],
  controllers: [UsersController],
  providers: [UsersService],
  exports: [UsersService],  // only if other modules need it
})
export class UsersModule {}
```

## Lazy Loading
- Use NestJS module lazy-loading only for serverless; not needed in standard apps
