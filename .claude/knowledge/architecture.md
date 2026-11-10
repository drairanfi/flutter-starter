# Architecture

Feature-first Clean architecture (Screaming): top-level folders name business
capabilities, not technical layers.

```
lib/
  main_{dev,staging,prod}.dart   entrypoints -> bootstrap(AppConfig)
  app.dart                       App: MaterialApp.router (theme, l10n, router)
  core/                          app-wide, feature-agnostic
    config/  router/  theme/  network/  error/  storage/  l10n/  utils/
  features/<name>/
    domain/        entities (freezed), repository interfaces
    data/          repository implementations, DTOs, repository provider
    presentation/  pages/  widgets/  providers/ (notifiers)
  shared/widgets/{atoms,molecules,organisms}
```

## Dependency direction

```
presentation -> domain <- data
      \            |         /
       +------> core <------+      shared/widgets -> core (never features)
```

## Runtime flow

1. `main_<env>.dart` builds `AppConfig` and calls `bootstrap` (`core/config/bootstrap.dart`).
2. `bootstrap` initialises `SharedPreferences` and overrides `appConfigProvider` and
   `sharedPreferencesProvider` in the root `ProviderScope`.
3. `App` watches `appRouterProvider` and `themeModeControllerProvider`.
4. Page -> notifier (`presentation/providers`) -> repository interface
   (`domain`) -> implementation (`data`) -> `dioProvider` / `secureStorageProvider`.
5. Dio errors become `Failure` in `ErrorMappingInterceptor`; the UI localises them.

## Swap points

- Repository provider in `features/<name>/data/<name>_repository_provider.dart`
  returns the **interface**. Example: `authRepositoryProvider` returns
  `MockAuthRepository` today; replace it there and nothing else changes.
- Auth guard: pure `authRedirect` in `core/router/auth_redirect.dart`, wired in
  `app_router.dart` and refreshed by listening to `authControllerProvider`.

## Where things go

| Thing | Location |
| --- | --- |
| Env/config, bootstrap, base providers | `core/config` |
| Routes, guard | `core/router` |
| Theme | `core/theme` |
| HTTP client, interceptors, error mapper | `core/network` |
| `Failure` hierarchy | `core/error` |
| Secure storage, `StorageKeys` | `core/storage` |
| ARB files, `context.l10n`, `Failure.localize` | `core/l10n` |
| Pure helpers (validators) | `core/utils` |
| UI shared by 2+ features | `shared/widgets/...` |

The `auth`, `home` and `settings` features are the reference examples.
