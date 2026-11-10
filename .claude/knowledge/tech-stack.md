# Tech stack

Source of truth: `pubspec.yaml`. Do not add dependencies without asking.

| Concern | Choice |
| --- | --- |
| SDK | Flutter 3.47.x, Dart `^3.13.7` |
| State / DI | `flutter_riverpod` 3 + `riverpod_annotation` / `riverpod_generator` (codegen only) |
| Models | `freezed` 4 + `json_serializable` |
| Routing | `go_router` with an auth redirect guard |
| HTTP | `dio` (auth, logging, error-mapping interceptors) |
| Storage | `flutter_secure_storage` (tokens), `shared_preferences` (prefs) |
| i18n | `flutter_localizations` + `intl`, ARB en/es, `flutter gen-l10n` |
| Theming | Material 3, `ColorScheme.fromSeed` in `core/theme/app_theme.dart` |
| Lints | `very_good_analysis` (`analysis_options.yaml`) |
| Tests | `flutter_test` + `mocktail` |
| Git hooks | `lefthook` (format, analyze, commit message check) |
| CI | `.github/workflows/ci.yml` (codegen, format, analyze, test, Android flavor builds) |

Platforms: Android, iOS, Web. Native flavors `dev`, `staging`, `prod` on Android
and iOS; web has none (use the dart-define file).

## Commands

```sh
flutter pub get
dart run build_runner build         # or: watch
flutter gen-l10n
dart format .
flutter analyze
flutter test --coverage
flutter run -t lib/main_dev.dart --flavor dev --dart-define-from-file=config/dev.json
```

Generated files are git-ignored; CI regenerates them.
