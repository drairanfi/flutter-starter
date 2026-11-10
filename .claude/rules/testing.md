# Testing

Stack: `flutter_test` + `mocktail`. Layout: `test/features/<n>/`, `test/core/<area>/`, `test/shared/`.

**Must have tests:** every notifier, route guard/redirect rule, error mapper, validator, repository
and shared widget. Assert behaviour (state, navigation, headers, rendered text), not internals.

- Notifiers: `ProviderContainer` with overrides, always `addTearDown(container.dispose)`.

```dart
class MockAuthRepository extends Mock implements AuthRepository {}

container = ProviderContainer(
  overrides: [authRepositoryProvider.overrideWithValue(repository)],
);
```

- Stub with `when(() => repo.x()).thenAnswer((_) async => v)` / `.thenThrow(const SomeFailure())`.
  Register fallback values only if you use `any()` on non-primitive types.
- HTTP: fake `HttpClientAdapter` on a Dio built with `buildDio` (see
  `test/core/network/error_mapping_test.dart`); do not mock Dio itself.
- Flows through the router: pump the real `App` in a `ProviderScope` overriding `appConfigProvider`,
  `sharedPreferencesProvider` (via `SharedPreferences.setMockInitialValues({})`) and the repository
  (see `test/core/router/auth_redirect_test.dart`).
- Widget tests wrap in `MaterialApp(home: Scaffold(body: child))` (see `test/shared/app_button_test.dart`).
- Pure logic (validators, `authRedirect`) is tested without Flutter bindings.
- No real network, timers or secure storage; use `InMemorySecureStorage`.
- New failure kind or route -> extend the mapper/redirect tests in the same change.
- Run: `flutter test` (CI uses `--coverage`).
