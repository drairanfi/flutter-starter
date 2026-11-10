import 'package:flutter_template/core/storage/secure_storage.dart';
import 'package:flutter_template/features/auth/data/mock_auth_repository.dart';
import 'package:flutter_template/features/auth/domain/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository_provider.g.dart';

/// Single place that decides which [AuthRepository] the app uses.
/// Replace [MockAuthRepository] with your real implementation here.
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    MockAuthRepository(ref.watch(secureStorageProvider));
