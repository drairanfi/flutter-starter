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
`baseApplicationId` and iOS `APP_BUNDLE_ID_BASE` (see "Changing ids and names").

Optional: install [lefthook](https://lefthook.dev) and run `lefthook install`
to enable the git hooks.

## Environments

Three entrypoints share `bootstrap()`:

| Env     | Entrypoint              | Config file            |
| ------- | ----------------------- | ---------------------- |
| dev     | `lib/main_dev.dart`     | `config/dev.json`      |
| staging | `lib/main_staging.dart` | `config/staging.json`  |
| prod    | `lib/main_prod.dart`    | `config/prod.json`     |

Each environment is also a native flavor (`dev`, `staging`, `prod`), so the
three can be installed side by side:

| Flavor  | Android applicationId             | iOS bundle id                         | App name         |
| ------- | --------------------------------- | ------------------------------------- | ---------------- |
| dev     | `com.example.flutter_template.dev`     | `com.example.flutterTemplate.dev`     | Template Dev     |
| staging | `com.example.flutter_template.staging` | `com.example.flutterTemplate.staging` | Template Staging |
| prod    | `com.example.flutter_template`         | `com.example.flutterTemplate`         | Template         |

```sh
# Run (replace dev with staging / prod)
flutter run -t lib/main_dev.dart --flavor dev --dart-define-from-file=config/dev.json

# Android
flutter build apk       --flavor prod -t lib/main_prod.dart --dart-define-from-file=config/prod.json
flutter build appbundle --flavor prod -t lib/main_prod.dart --dart-define-from-file=config/prod.json

# iOS (add --no-codesign for unsigned builds; use `flutter build ipa` for release archives)
flutter build ios --flavor prod -t lib/main_prod.dart --dart-define-from-file=config/prod.json
```

Every command needs all three of `--flavor`, `-t` and
`--dart-define-from-file` for the same environment. VS Code launch
configurations (`.vscode/launch.json`) already do this.

### Changing ids and names

- **Android applicationId**: edit the `baseApplicationId` constant at the top
  of `android/app/build.gradle.kts` (flavor suffixes are appended). The
  `namespace` there and the `MainActivity` package are separate; change them
  only if you also move the Kotlin sources.
- **iOS bundle id**: edit `APP_BUNDLE_ID_BASE` in `ios/Flutter/Base.xcconfig`.
  The `RunnerTests` target keeps its own hard-coded id in Xcode build settings.
- **App name**: Android `resValue("string", "app_name", ...)` per flavor in
  `build.gradle.kts`; iOS `APP_DISPLAY_NAME` in
  `ios/Flutter/{dev,staging,prod}.xcconfig` (read by `Info.plist`).
- **iOS layout**: schemes `dev`/`staging`/`prod` map to build configurations
  `Debug-<flavor>`, `Release-<flavor>`, `Profile-<flavor>`, each backed by
  `ios/Flutter/<Mode>-<flavor>.xcconfig`. Keep these names: Flutter matches
  `--flavor` against them. Plain `flutter run` (no flavor) still uses the
  original `Debug`/`Release`/`Profile` configurations and the `Runner` scheme.

`AppConfig` (`lib/core/config/app_config.dart`) reads `ENV`, `API_BASE_URL` and
`ENABLE_LOGGING` via `String.fromEnvironment`. If no define file is passed,
each entrypoint falls back to its own environment defaults. The JSON files are
**examples without secrets**: dart-defines are compiled into the binary and are
extractable. Real secrets belong on a backend. Use `config/*.local.json`
(git-ignored) for personal overrides.

### Still per-project work

- Per-flavor launcher icons (all flavors currently share the default icon).
- Per-flavor `google-services.json` / `GoogleService-Info.plist`, signing
  configs (Android release currently uses debug keys), deep link hosts and
  push notification setup.
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
- See `AGENTS.md`, `RULES.md` and `.claude/` for the full architecture rules (also useful for humans).

## AI harness

The repo ships configuration for AI coding agents. It works with both Claude Code and
OpenCode, with `.claude/` as the single source of truth.

| Path | Purpose |
| ---- | ------- |
| `AGENTS.md` | Entry point for agents (`CLAUDE.md` imports it) |
| `RULES.md` | One-page rules card |
| `.claude/knowledge/` | Critical constraints, architecture, tech stack |
| `.claude/rules/` | Short rules per topic (Riverpod, routing, l10n, tests, ...) |
| `.claude/agents/` | `feature-architect`, `flutter-builder`, `code-reviewer`, `doc-gardener`, `ux-ui-designer` |
| `.claude/commands/` | `/new-feature <name>`, `/figma-to-flutter <url>`, `/verify` |
| `.claude/skills/` | Task checklists (`riverpod`, `freezed-models`, `go-router`, `grill-me`, ...) |
| `.claude/plans/` | Feature plans written by the architect (git-ignored, only `.gitkeep` is tracked) |
| `.claude/settings.json` | Claude Code permissions (secrets denied) and the `dart format` hook |
| `.mcp.json` / `opencode.json` | Dart/Flutter MCP server and Figma Desktop MCP; OpenCode also holds permissions |
| `.opencode/` | OpenCode view: `commands` is a symlink; `agents` is generated |

Typical flow: describe the feature, `feature-architect` writes a plan, `flutter-builder`
implements it, `code-reviewer` audits, `/verify` runs the full pipeline. Use
`/new-feature profile` to scaffold a feature directly.

After editing `.claude/agents/*`, run `sh scripts/sync_opencode_agents.sh` to refresh
`.opencode/agents/` (the formats differ, so those files cannot be symlinks). Figma
commands need Figma Desktop running with its MCP server enabled.

## Known limitations

- Icons and splash use Flutter defaults for every flavor.
- No crash reporting or analytics wiring; add them in `bootstrap()`.
