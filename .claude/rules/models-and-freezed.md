# Models and freezed

- Domain entities are immutable freezed classes in `features/<n>/domain/`.
- Freezed 3+/4 syntax: `@freezed abstract class` with `const factory ... = _Name;`.

```dart
part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({required String id, required String email}) = _User;
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

- Add `fromJson` only when the model is persisted or parsed from JSON (then also `part '*.g.dart'`).
- Domain stays pure: only `freezed_annotation`, `json_annotation`, `core/error`.
- Wire DTOs (API shapes) live in `data/`; map them to entities there. Do not leak DTOs into
  `presentation`.
- Use `copyWith` for updates; never mutate. Prefer `required` named params.
- Sealed classes / enums for closed sets (`Failure`, `Environment`); `switch` expressions must be
  exhaustive, no `default` that hides new cases.
- After changes: `dart run build_runner build`. Never edit `*.freezed.dart` / `*.g.dart`.
