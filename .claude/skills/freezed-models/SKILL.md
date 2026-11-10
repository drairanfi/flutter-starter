---
name: freezed-models
description: Use when creating or editing freezed entities, DTOs or JSON serialization in this Flutter repo.
---

Read `.claude/rules/models-and-freezed.md`; example: `lib/features/auth/domain/user.dart`.

1. Entity in `features/<n>/domain/`: `@freezed abstract class X with _$X { const factory X({...}) = _X; }`.
2. Parts: `x.freezed.dart`, plus `x.g.dart` only when `fromJson` exists.
3. DTOs live in `data/` and are mapped to entities; domain never imports Dio or Flutter UI.
4. Closed sets: sealed classes or enums with exhaustive `switch`.
5. Run `dart run build_runner build`. Never edit generated files.
