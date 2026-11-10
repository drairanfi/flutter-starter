# Flutter Template

Production-grade Flutter starter: Screaming + Clean architecture, feature-first,
Riverpod (codegen), go_router with an auth guard, dio with an interceptor
layer, Material 3 theming, ARB localisation (en/es) and a strict quality
toolchain.

Platforms: Android, iOS, Web. A mock auth repository ships out of the box so
the app runs with no backend (sign in with any valid email and the password
`password123`).

## Quickstart

```sh
flutter pub get
dart run build_runner build        # Riverpod / freezed / json code
flutter gen-l10n                   # localisation (also runs on pub get / build)

flutter run -t lib/main_dev.dart --dart-define-from-file=config/dev.json
```

Rename the package after cloning: change `name:` in `pubspec.yaml`, replace
`flutter_template` in imports (`rg -l flutter_template lib test | xargs sd
'package:flutter_template' 'package:<new_name>'`), then update the Android
`applicationId` and iOS bundle identifier (`com.example.*`).

Optional: install [lefthook](https://lefthook.dev) and run `lefthook install`
to enable the git hooks.

## Environments

Three entrypoints share `bootstrap()`:

| Env     | Entrypoint              | Config file            |
| ------- | ----------------------- | ---------------------- |
| dev     | `lib/main_dev.dart`     | `config/dev.json`      |
| staging | `lib/main_staging.dart` | `config/staging.json`  |
| prod    | `lib/main_prod.dart`    | `config/prod.json`     |

```sh
flutter run   -t lib/main_staging.dart --dart-define-from-file=config/staging.json
flutter build apk -t lib/main_prod.dart --dart-define-from-file=config/prod.json
```

`AppConfig` (`lib/core/config/app_config.dart`) reads `ENV`, `API_BASE_URL` and
`ENABLE_LOGGING` via `String.fromEnvironment`. If no define file is passed,
each entrypoint falls back to its own environment defaults. The JSON files are
**examples without secrets**: dart-defines are compiled into the binary and are
extractable. Real secrets belong on a backend. Use `config/*.local.json`
(git-ignored) for personal overrides.

### What native flavors would still need

Entrypoints and dart-defines separate *Dart-side* configuration only. For
distinct installable apps per environment you still need to add:

- **Android**: `productFlavors` (dev/staging/prod) in
  `android/app/build.gradle.kts` with a distinct `applicationIdSuffix`, app
  label (`resValue`), and per-flavor `google-services.json` /
  signing configs. Then run with `--flavor <name>`.
- **iOS**: one Xcode scheme and build configuration per environment
  (`Debug-dev`, `Release-staging`, ...), `.xcconfig` files for bundle id and
  display name, per-scheme `GoogleService-Info.plist`, and matching
  `--flavor` names.
- **Both**: per-environment launcher icons, deep link / universal link hosts,
  push notification and signing setup, and CI jobs that pass `--flavor` plus
  the matching `-t` / `--dart-define-from-file`.
- **Web**: no flavors; use the dart-define file and deploy per environment.

## Structure

```
lib/
├── main_{dev,staging,prod}.dart   # entrypoints
├── app.dart                       # MaterialApp.router
├── core/                          # app-wide, feature-agnostic infrastructure
│   ├── config/                    # AppConfig, bootstrap, base providers
│   ├── router/                    # go_router + auth redirect guard
│   ├── theme/                     # Material 3 themes, ThemeMode persistence
│   ├── network/                   # dio client, interceptors, error mapping
│   ├── error/                     # sealed Failure hierarchy
│   ├── storage/                   # SecureStorage interface + implementations
│   ├── l10n/                      # ARB files, generated localisations
│   └── utils/                     # pure helpers (validators, ...)
├── features/                      # one folder per business capability
│   ├── auth/ {data, domain, presentation/{pages,widgets,providers}}
│   ├── home/
│   └── settings/
└── shared/widgets/                # atomic design, feature-agnostic UI
    ├── atoms/                     # AppButton
    ├── molecules/                 # LabeledTextField
    └── organisms/                 # AppScaffold
```

Dependency direction (inner layers never import outer ones):

```
presentation -> domain <- data
      \            |         /
       +------> core <------+      shared/widgets -> core (never features)
```

## Commands

| Task                    | Command                                               |
| ----------------------- | ----------------------------------------------------- |
| Install deps            | `flutter pub get`                                     |
| Generate code           | `dart run build_runner build`                         |
| Watch codegen           | `dart run build_runner watch`                         |
| Generate l10n           | `flutter gen-l10n`                                    |
| Format                  | `dart format .`                                       |
| Analyze                 | `flutter analyze`                                     |
| Test (with coverage)    | `flutter test --coverage`                             |

Generated files (`*.g.dart`, `*.freezed.dart`, `lib/core/l10n/generated/`) are
git-ignored; CI regenerates them.

## Add a feature

Example: `profile`.

1. Create `lib/features/profile/{data,domain,presentation/{pages,widgets,providers}}`.
2. **Domain**: entities (freezed) and a repository interface
   (`abstract interface class ProfileRepository`). Pure Dart, no Flutter/dio.
3. **Data**: implementation using `dioProvider`; convert `DioException` to
   `Failure` (`e.error as Failure`) and expose it through a
   `@Riverpod(keepAlive: true) ProfileRepository profileRepository(Ref ref)`
   provider.
4. **Presentation**: a `@riverpod` notifier in `providers/`, pages and widgets
   that only talk to providers.
5. Add strings to **both** ARB files, then register the route in
   `core/router/app_routes.dart` + `app_router.dart`.
6. Run codegen, add tests mirroring the path under `test/features/profile/`.

### Swapping the mock auth backend

Implement `AuthRepository` (e.g. `RemoteAuthRepository` using `dioProvider`,
persisting the token under `StorageKeys.accessToken`) and return it from
`authRepositoryProvider` in
`lib/features/auth/data/auth_repository_provider.dart`. Nothing else changes.

## Conventions

- Conventional Commits (`feat(auth): ...`), enforced by lefthook via
  `scripts/check_commit_msg.sh` (no Node required).
- Lints: `very_good_analysis`; generated files are excluded.
- Errors: repositories throw a `Failure`; the UI maps it with
  `Failure.localize(l10n)`.
- UI strings live in ARB files; never hard-code user-facing text.
- Route paths only through `AppRoutes`.
- Tests mirror `lib/` and use `mocktail`; override providers instead of
  mocking widgets.
- See `CLAUDE.md` for the full architecture rules (also useful for humans).

## Known limitations

- Native flavors are not configured (see above).
- App name, icons and splash use Flutter defaults.
- No crash reporting or analytics wiring; add them in `bootstrap()`.
