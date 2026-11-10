# CLAUDE.md

Architecture rules for AI agents (and humans) working in this repo.
Stack: Flutter, Riverpod 3 + codegen, freezed, go_router, dio.

## Layers and dependency direction

Feature-first, Clean inside each feature:

```
features/<name>/
  domain/        entities, repository interfaces, use cases (pure Dart)
  data/          repository implementations, DTOs, data sources, repo providers
  presentation/  pages/, widgets/, providers/ (notifiers holding UI state)
```

Allowed imports:

- `domain` imports nothing from `data`, `presentation`, or Flutter UI.
  Only `freezed_annotation`/`json_annotation` and `core/error`.
- `data` imports its own `domain` and `core/*`. Never `presentation`.
- `presentation` imports its own `domain`, `data` only for provider wiring,
  `core/*` and `shared/*`.
- A feature must **not** import another feature's `data` or `presentation`.
  Share via `domain` interfaces or promote the code to `core/` / `shared/`.
- `core/*` never imports `features/*`. Sole exception: `core/router`
  (composition root: it wires pages) and `core/l10n`-style plain helpers.
- `shared/widgets` is feature-agnostic: no providers from features, no
  feature imports. Atomic design: `atoms` -> `molecules` -> `organisms`.

## Where things go

| Thing                              | Location                                  |
| ---------------------------------- | ----------------------------------------- |
| Env/config, bootstrap              | `core/config`                             |
| Routes and guard                   | `core/router` (paths in `AppRoutes`)      |
| Theme                              | `core/theme`                              |
| HTTP client, interceptors          | `core/network`                            |
| `Failure` types                    | `core/error`                              |
| Secure storage / key names         | `core/storage`                            |
| ARB files, l10n helpers            | `core/l10n`                               |
| Pure helpers (validators, ...)     | `core/utils`                              |
| Reusable UI used by 2+ features    | `shared/widgets/{atoms,molecules,organisms}` |

## Naming

- Files: `snake_case.dart`. One public concept per file.
- Interfaces: `abstract interface class FooRepository`; implementations
  `RemoteFooRepository`, `MockFooRepository`.
- Notifiers: `FooController` (provider `fooControllerProvider`).
- Pages: `FooPage`; widgets that are not routes: no `Page` suffix.
- Tests mirror the `lib/` path: `lib/a/b.dart` -> `test/a/b_test.dart`.

## Riverpod conventions

- Use codegen (`@riverpod` / `@Riverpod(keepAlive: true)`) only. No
  hand-written `Provider(...)`, `StateProvider`, or `StateNotifier`.
- Every file with annotations needs `part 'x.g.dart';`. After changing any
  annotated/freezed/json class run `dart run build_runner build`.
- Repository providers live in the feature's `data/` and return the
  **interface** type; that is the single swap point.
- Notifiers hold UI/session state; they call repositories and never touch
  Dio, storage or `BuildContext`.
- In widgets: `ref.watch` in `build`, `ref.read` only in callbacks.
- Async state is `AsyncValue`; use `AsyncValue.guard`. Riverpod keeps the
  previous value while loading/erroring; the router relies on this.
- Config/prefs providers (`appConfigProvider`, `sharedPreferencesProvider`)
  are overridden in `bootstrap()` and in tests.

## Errors

- Repositories throw a `Failure` (sealed, `core/error/failure.dart`). Dio
  errors are already mapped by `ErrorMappingInterceptor`: unwrap with
  `e.error as Failure`.
- Add new failure kinds to the sealed class, then fix the exhaustive
  `switch` in `core/l10n/l10n.dart` and the mapper.
- Never show `Failure.message` to users; use `localize(l10n)`.

## UI rules

- No hard-coded user-facing strings: add keys to **both**
  `app_en.arb` and `app_es.arb`, then `flutter gen-l10n`.
- Colors/typography come from `Theme.of(context)`; no raw `Color(...)` in
  features.
- Navigation through `go_router` (`context.go/push`) with `AppRoutes`.

## Testing expectations

- Every notifier, redirect/guard rule, mapper and shared widget has tests.
- `flutter_test` + `mocktail`. Fake at the repository / HTTP adapter
  boundary; override providers via `ProviderContainer(overrides: [...])`.
- Widget flows that cross the router use the real `App` with overridden
  providers (see `test/core/router/auth_redirect_test.dart`).
- Tests assert behaviour (state, navigation, headers), not implementation.

## Definition of done

Run, in order, and keep all green:

```sh
dart run build_runner build
flutter gen-l10n
dart format --set-exit-if-changed .
flutter analyze        # zero issues
flutter test
```

Commits follow Conventional Commits. Never commit secrets; `config/*.json`
are non-secret examples. Do not edit generated files.
