# Networking and errors

- Use the shared client: `ref.watch(dioProvider)` (`core/network/dio_client.dart`). Never
  create a `Dio()` in a feature. Base URL comes from `AppConfig.apiBaseUrl`.
- Interceptor order (fixed): `AuthInterceptor` (Bearer token from `StorageKeys.accessToken`),
  `LoggingInterceptor` (debug + `ENABLE_LOGGING` only), `ErrorMappingInterceptor` (last).
- Every `DioException` reaches the repository with a `Failure` in `.error`. Unwrap it:

```dart
try {
  final res = await _dio.get<Map<String, dynamic>>('/profile');
  return ProfileDto.fromJson(res.data!).toEntity();
} on DioException catch (e) {
  throw e.error as Failure;
}
```

- `Failure` is sealed (`core/error/failure.dart`): `NetworkFailure`, `TimeoutFailure`,
  `UnauthorizedFailure`, `InvalidCredentialsFailure`, `NotFoundFailure`, `ServerFailure`,
  `UnknownFailure`. Repositories throw `Failure`; they never return `Result` wrappers here.
- New failure kind: add the `final class`, map it in `core/network/error_mapper.dart` if
  HTTP-derived, extend the exhaustive `switch` in `core/l10n/l10n.dart`, add an ARB key in en + es.
- UI: `localizeError(error, l10n)` or `failure.localize(l10n)`. Never show `Failure.message`
  or raw exception text.
- Tokens only in `SecureStorage`; never log tokens, never put secrets in `config/*.json`.
- Offline/dev: implement the repository interface with a mock (see `MockAuthRepository`).
