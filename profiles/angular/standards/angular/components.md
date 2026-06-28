# Angular Components

Source: angular.dev/style-guide (official Angular team)

## Structure (standalone preferred in Angular 17+)
```ts
@Component({
  selector: 'app-user-profile',
  standalone: true,
  imports: [...],
  templateUrl: './user-profile.component.html',
  styleUrl: './user-profile.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class UserProfileComponent {
  // 1. Injected deps via inject()
  private userService = inject(UserService);

  // 2. Inputs / Outputs (readonly)
  readonly userId = input.required<string>();
  readonly userChanged = output<User>();

  // 3. Signals / computed
  user = signal<User | null>(null);
  displayName = computed(() => this.user()?.name ?? '');

  // 4. Lifecycle hooks
  ngOnInit() { ... }

  // 5. Methods
  protected handleSave() { ... }
}
```

## Rules
- Use `ChangeDetectionStrategy.OnPush` by default
- Use `inject()` instead of constructor injection
- Mark template-only members as `protected`
- Mark inputs/outputs/queries as `readonly`
- Extract complex template logic into `computed()` signals
- Keep components UI-focused; business logic belongs in services
- Use `[class]` and `[style]` bindings instead of `NgClass`/`NgStyle`

## Event Handlers
- Name after the action: `saveUser()` not `handleButtonClick()`
