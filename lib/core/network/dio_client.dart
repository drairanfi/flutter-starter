import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_template/core/config/app_config.dart';
import 'package:flutter_template/core/config/providers.dart';
import 'package:flutter_template/core/network/interceptors.dart';
import 'package:flutter_template/core/storage/secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

/// Builds a configured [Dio]. Interceptor order matters: auth first, logging
/// (debug only) next, error mapping last so it sees the final error.
Dio buildDio({
  required AppConfig config,
  required TokenReader readToken,
  bool enableLogging = kDebugMode,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
    ),
  );
  dio.interceptors.addAll([
    AuthInterceptor(readToken),
    if (enableLogging) LoggingInterceptor(),
    ErrorMappingInterceptor(),
  ]);
  return dio;
}

/// App-wide HTTP client. Repositories that talk to a real backend depend on
/// this provider.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final config = ref.watch(appConfigProvider);
  final storage = ref.watch(secureStorageProvider);
  return buildDio(
    config: config,
    readToken: () => storage.read(StorageKeys.accessToken),
    enableLogging: kDebugMode && config.enableLogging,
  );
}
