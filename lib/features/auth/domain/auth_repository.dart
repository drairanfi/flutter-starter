import 'package:flutter_template/features/auth/domain/user.dart';

/// Contract for authentication. Implementations throw a `Failure` on error.
abstract interface class AuthRepository {
  /// Signs in and persists the session. Throws `InvalidCredentialsFailure`
  /// (or another `Failure`) when it cannot.
  Future<User> signIn({required String email, required String password});

  /// Returns the persisted user, or null when there is no valid session.
  Future<User?> restoreSession();

  /// Clears the persisted session.
  Future<void> signOut();
}
