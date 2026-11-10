import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage.g.dart';

/// Keys used in secure storage. Keep them in one place.
abstract final class StorageKeys {
  static const accessToken = 'access_token';
  static const currentUser = 'current_user';
}

/// Abstraction over encrypted key/value storage so it can be faked in tests.
abstract interface class SecureStorage {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

/// [SecureStorage] backed by the platform keychain/keystore.
class FlutterSecureStorageImpl implements SecureStorage {
  const FlutterSecureStorageImpl([
    this._storage = const FlutterSecureStorage(),
  ]);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

/// In-memory implementation, useful for tests and previews.
class InMemorySecureStorage implements SecureStorage {
  final Map<String, String> _data = {};

  @override
  Future<String?> read(String key) async => _data[key];

  @override
  Future<void> write(String key, String value) async => _data[key] = value;

  @override
  Future<void> delete(String key) async => _data.remove(key);
}

@Riverpod(keepAlive: true)
SecureStorage secureStorage(Ref ref) => const FlutterSecureStorageImpl();
