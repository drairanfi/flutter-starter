import 'dart:convert';

import 'package:flutter_template/core/error/failure.dart';
import 'package:flutter_template/core/storage/secure_storage.dart';
import 'package:flutter_template/features/auth/domain/auth_repository.dart';
import 'package:flutter_template/features/auth/domain/user.dart';

/// Offline [AuthRepository] for development and demos.
///
/// Accepts any email with the password [validPassword]. Swap it for a real
/// implementation (see README) by overriding `authRepositoryProvider`.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository(
    this._storage, {
    this.latency = const Duration(milliseconds: 600),
  });

  static const validPassword = 'password123';

  final SecureStorage _storage;
  final Duration latency;

  @override
  Future<User> signIn({required String email, required String password}) async {
    await Future<void>.delayed(latency);
    if (password != validPassword) throw const InvalidCredentialsFailure();

    final user = User(
      id: 'mock-user-1',
      email: email.trim(),
      name: email.split('@').first,
    );
    await _storage.write(StorageKeys.accessToken, 'mock-token');
    await _storage.write(StorageKeys.currentUser, jsonEncode(user.toJson()));
    return user;
  }

  @override
  Future<User?> restoreSession() async {
    final token = await _storage.read(StorageKeys.accessToken);
    final raw = await _storage.read(StorageKeys.currentUser);
    if (token == null || raw == null) return null;
    try {
      return User.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      await signOut();
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _storage.delete(StorageKeys.accessToken);
    await _storage.delete(StorageKeys.currentUser);
  }
}
