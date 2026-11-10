# Flavors and config

- Three environments `dev`, `staging`, `prod`: entrypoints `lib/main_<env>.dart`, config
  `config/<env>.json`, native flavors on Android (`android/app/build.gradle.kts`) and iOS
  (`ios/Flutter/*.xcconfig`, schemes + `Debug-/Release-/Profile-<flavor>`). Web has no flavors.
- Always pass all three together:

```sh
flutter run -t lib/main_dev.dart --flavor dev --dart-define-from-file=config/dev.json
```

- `AppConfig` (`lib/core/config/app_config.dart`) reads `ENV`, `API_BASE_URL`, `ENABLE_LOGGING` via
  `String.fromEnvironment`; entrypoints supply a default environment.
- Read config only through `ref.watch(appConfigProvider)`. Never call `String.fromEnvironment`
  elsewhere. New setting: add the field, parse it in `fromEnvironment`, add it to all three JSON
  files, document it in README.
- `config/*.json` are public examples: dart-defines ship inside the binary. Never put secrets in
  them. Personal overrides: `config/*.local.json` (git-ignored).
- Application ids: edit only `baseApplicationId` (Gradle) or `APP_BUNDLE_ID_BASE`
  (`ios/Flutter/Base.xcconfig`). Do not hand-edit bundle ids in `project.pbxproj`; keep the iOS
  configuration names intact.
- Per-flavor Firebase files and signing configs are secrets: do not read, create or edit them.
