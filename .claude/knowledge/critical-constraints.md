# Critical constraints (read first)

Hard rules. Breaking one means the change is wrong, whatever else works.

1. **Dependency direction.** `presentation -> domain <- data`; both use `core/`.
   `domain` is pure Dart (no Flutter UI, no Dio, no storage). `core/` never imports
   `features/` (sole exception: `core/router`, the composition root).
2. **No cross-feature imports** of another feature's `data/` or `presentation/`.
   Share through a `domain` interface or promote the code to `core/` or `shared/`.
3. **`shared/widgets` is feature-agnostic.** It never imports `features/`.
4. **No business logic in widgets.** Widgets render state and forward events to a
   notifier. Rules, mapping and I/O live in domain, data or notifiers.
5. **Riverpod codegen only.** No hand-written `Provider(...)`, `StateProvider`,
   `StateNotifier`. `ref.watch` in `build`, `ref.read` in callbacks only.
6. **Errors are `Failure`s.** Repositories throw `Failure`; the UI shows
   `failure.localize(l10n)` / `localizeError`, never `Failure.message`.
7. **No hard-coded user-facing strings.** Add keys to both `app_en.arb` and
   `app_es.arb`, then `flutter gen-l10n`.
8. **No raw colors or text styles in features.** Use `Theme.of(context)`.
9. **Routes only through `AppRoutes`.** No path literals outside
   `lib/core/router/app_routes.dart`.
10. **No secrets in the repo.** `config/*.json` are public examples. Never read or
    edit `.env*`, keystores, `key.properties`, `google-services.json`,
    `GoogleService-Info.plist`, `.p12`, `.mobileprovision`.
11. **Generated files are never edited or committed**: `*.g.dart`,
    `*.freezed.dart`, `lib/core/l10n/generated/`. Change the source and regenerate.
12. **Flavors.** Always run/build with `--flavor <env> -t lib/main_<env>.dart
    --dart-define-from-file=config/<env>.json`. Never hand-edit bundle ids in
    `project.pbxproj`.
13. **No `print`.** No new dependency without asking.
14. **Identifiers, comments and UI copy keys are English.**
15. **Done means green:** codegen, `flutter gen-l10n`, `dart format`,
    `flutter analyze` (zero issues), `flutter test`.
