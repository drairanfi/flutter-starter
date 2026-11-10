/// Domain-level error type. Repositories throw a [Failure]; the presentation
/// layer pattern-matches on it exhaustively.
sealed class Failure implements Exception {
  const Failure([this.message]);

  /// Optional technical detail, never shown to end users directly.
  final String? message;

  @override
  String toString() => 'Failure(${message ?? ''})';
}

/// No connectivity or the host could not be reached.
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);
}

/// Connect, send or receive timeout.
final class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message]);
}

/// HTTP 401: missing, invalid or expired credentials.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message]);
}

/// Login rejected because of wrong email/password.
final class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure([super.message]);
}

/// HTTP 404.
final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message]);
}

/// HTTP 5xx or any unexpected non-success status.
final class ServerFailure extends Failure {
  const ServerFailure({this.statusCode, String? message}) : super(message);

  final int? statusCode;
}

/// Anything that could not be classified.
final class UnknownFailure extends Failure {
  const UnknownFailure([super.message]);
}
