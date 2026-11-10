# Riverpod

- Codegen only: `@riverpod` or `@Riverpod(keepAlive: true)`. No hand-written `Provider`,
  `StateProvider`, `StateNotifier`, `ChangeNotifier`.
- Each annotated file needs `part '<file>.g.dart';`. Run `dart run build_runner build` after edits.
- `keepAlive: true` for app-wide things (repositories, auth, config, router, theme mode).
  Plain `@riverpod` (auto-dispose) for screen-scoped state.
- Repository providers live in `features/<n>/data/` and return the **interface**:

```dart
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    MockAuthRepository(ref.watch(secureStorageProvider));
```

- Notifiers (`FooController`) hold UI/session state and call repositories. They never touch
  Dio, storage or `BuildContext`.
- `build` is pure: read dependencies with `ref.watch`; no navigation, no snackbars, no
  fire-and-forget writes. Side effects go in methods called from callbacks.
- Widgets: `ref.watch` in `build`; `ref.read` only in callbacks (`onPressed`, `_submit`).
  Use `ref.listen` for one-off reactions (dialogs, snackbars).
- Async state is `AsyncValue`. Mutations use `AsyncValue.guard`:

```dart
state = const AsyncLoading();
state = await AsyncValue.guard(() => repository.signIn(email: e, password: p));
```

- Render with `auth.isLoading`, `auth.hasError` + `localizeError(auth.error!, l10n)`, `auth.value`
  (or `.when`/`switch`). Riverpod keeps the previous value while loading; the router relies on it.
- Config/prefs providers (`appConfigProvider`, `sharedPreferencesProvider`) throw until
  overridden in `bootstrap()`; tests must override them when the tree reads them.
- Code that is not a widget receives `Ref`, never `WidgetRef`.
