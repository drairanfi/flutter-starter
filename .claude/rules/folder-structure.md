# Folder structure

```
lib/features/<name>/
  domain/<entity>.dart, <name>_repository.dart
  data/<impl>_<name>_repository.dart, <name>_repository_provider.dart
  presentation/pages/<name>_page.dart
  presentation/widgets/<widget>.dart
  presentation/providers/<name>_controller.dart
```

- One public concept per file. Generated parts (`*.g.dart`, `*.freezed.dart`) sit next to the source.
- Create the folder only when it has content, but keep the `domain/data/presentation` split.
- Code used by 2+ features moves to `core/` (non-UI) or `shared/widgets/` (UI). Never import across features.
- New route: path in `core/router/app_routes.dart`, `GoRoute` in `core/router/app_router.dart`.
- ARB keys go in `lib/core/l10n/arb/app_en.arb` and `app_es.arb`.
- Tests: `test/features/<name>/`, `test/core/<area>/`, `test/shared/`.
- Reference: `lib/features/auth` (full), `lib/features/settings` (UI only).
