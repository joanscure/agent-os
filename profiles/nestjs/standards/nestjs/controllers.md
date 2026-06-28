# NestJS Controllers

Source: docs.nestjs.com (official NestJS docs)

## Rules
- Controllers handle HTTP only: parse request, call service, return response
- No business logic in controllers — delegate everything to services
- One controller per resource (UsersController, OrdersController)
- Use route-level guards, not middleware, for auth

## Naming
- File: `users.controller.ts`
- Class: `UsersController`
- Decorator: `@Controller('users')`

## Template
```ts
@Controller('users')
@UseGuards(JwtAuthGuard)
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get()
  findAll(): Promise<User[]> {
    return this.usersService.findAll();
  }

  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number): Promise<User> {
    return this.usersService.findOne(id);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  create(@Body() createUserDto: CreateUserDto): Promise<User> {
    return this.usersService.create(createUserDto);
  }

  @Patch(':id')
  update(@Param('id', ParseIntPipe) id: number, @Body() dto: UpdateUserDto) {
    return this.usersService.update(id, dto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  remove(@Param('id', ParseIntPipe) id: number) {
    return this.usersService.remove(id);
  }
}
```

## Pipes
- Use `ParseIntPipe`, `ParseUUIDPipe` for route params
- Use `ValidationPipe` globally for DTO validation
