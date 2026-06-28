# NestJS Services

Source: docs.nestjs.com (official NestJS docs)

## Rules
- Services own ALL business logic; controllers and other services call them
- `@Injectable()` on every service
- One service per feature domain; don't bundle unrelated logic
- Services must be framework-agnostic in their logic (no `Request`/`Response` imports)

## Error Handling
- Throw NestJS built-in exceptions — they auto-map to HTTP responses:
  - `NotFoundException` → 404
  - `BadRequestException` → 400
  - `UnauthorizedException` → 401
  - `ForbiddenException` → 403
  - `ConflictException` → 409
- Never let DB/ORM exceptions bubble raw to the controller

## Template
```ts
@Injectable()
export class UsersService {
  constructor(private readonly usersRepository: UsersRepository) {}

  async findOne(id: number): Promise<User> {
    const user = await this.usersRepository.findById(id);
    if (!user) throw new NotFoundException(`User ${id} not found`);
    return user;
  }

  async create(dto: CreateUserDto): Promise<User> {
    const existing = await this.usersRepository.findByEmail(dto.email);
    if (existing) throw new ConflictException('Email already registered');
    return this.usersRepository.create(dto);
  }
}
```
