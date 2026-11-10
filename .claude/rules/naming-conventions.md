# Naming conventions

All identifiers, comments, commit messages and docs are **English**, even when
the business domain or the conversation is in another language. Only ARB values
(user-facing copy) may be translated.

| Kind | Convention | Example |
| --- | --- | --- |
| File | `snake_case.dart` | `auth_controller.dart` |
| Type | `UpperCamelCase` | `LoginPage` |
| Member, variable | `lowerCamelCase` | `restoreSession` |
| Repository interface | `abstract interface class FooRepository` | `AuthRepository` |
| Implementation | `<Kind>FooRepository` | `MockAuthRepository`, `RemoteFooRepository` |
| Repository provider | `fooRepository` -> `fooRepositoryProvider` | `authRepositoryProvider` |
| Notifier | `FooController` -> `fooControllerProvider` | `AuthController` |
| Page (routed) | `FooPage` | `SettingsPage` |
| Widget (not routed) | no `Page` suffix | `ThemeModeSelector` |
| Route constant | `AppRoutes.fooBar` | `AppRoutes.settings` |
| Failure | `FooFailure` | `NotFoundFailure` |
| ARB key | `lowerCamelCase`, prefixed by area | `loginTitle`, `errorNetwork`, `validationEmailInvalid` |
| Test file | `<subject>_test.dart` | `auth_controller_test.dart` |

- Booleans read as questions: `isLoading`, `isSignedIn`, `hasError`.
- No abbreviations except well-known (`id`, `url`, `l10n`).
- Do not use Spanish (or any non-English) words in identifiers.
