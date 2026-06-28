# NestJS DTOs

Source: docs.nestjs.com (official NestJS docs) + class-validator

## Rules
- DTOs define the shape of incoming requests; entities define the DB schema — keep them separate
- Use `class-validator` decorators for validation
- Use `class-transformer` with `@Exclude()` and `@Expose()` to control what's returned

## Naming
- `CreateUserDto` — for POST body
- `UpdateUserDto` — for PATCH body (use `PartialType(CreateUserDto)`)
- `UserResponseDto` — for outgoing data (if you want to hide DB fields)

## Template
```ts
// create-user.dto.ts
export class CreateUserDto {
  @IsString()
  @MinLength(2)
  @MaxLength(50)
  name: string;

  @IsEmail()
  email: string;

  @IsString()
  @MinLength(8)
  password: string;
}

// update-user.dto.ts
export class UpdateUserDto extends PartialType(CreateUserDto) {}
```

## Global Validation Pipe
Register once in `main.ts`:
```ts
app.useGlobalPipes(new ValidationPipe({
  whitelist: true,       // strip unknown properties
  forbidNonWhitelisted: true,
  transform: true,       // auto-transform to DTO class
}));
```

## Swagger
Add `@ApiProperty()` decorators for auto-generated OpenAPI docs:
```ts
@ApiProperty({ example: 'john@example.com' })
@IsEmail()
email: string;
```
