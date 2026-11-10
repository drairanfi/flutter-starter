---
name: flutter-testing
description: Use when writing or fixing tests (flutter_test, mocktail, provider overrides, router flows) in this Flutter repo.
---

Read `.claude/rules/testing.md`. Examples: `test/features/auth/auth_controller_test.dart`, `test/core/network/error_mapping_test.dart`, `test/core/router/auth_redirect_test.dart`, `test/shared/app_button_test.dart`.

1. Notifier: `ProviderContainer(overrides: [repoProvider.overrideWithValue(mock)])` + `addTearDown(container.dispose)`.
2. Mock with `class MockX extends Mock implements X {}`; stub with `when(() => ...)`.
3. HTTP: fake `HttpClientAdapter` on `buildDio`; do not mock Dio.
4. Router flow: real `App` in `ProviderScope`, overriding `appConfigProvider`, `sharedPreferencesProvider`, the repository.
5. Assert behaviour, not implementation. Run `flutter test`.
