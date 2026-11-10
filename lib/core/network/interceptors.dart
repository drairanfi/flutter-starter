import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter_template/core/network/error_mapper.dart';

/// Supplies the current access token (or null when signed out).
typedef TokenReader = Future<String?> Function();

/// Adds `Authorization: Bearer <token>` when a token is available.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._readToken);

  final TokenReader _readToken;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

/// Logs requests and responses. Only attach it in debug builds.
/// The Authorization header is redacted.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    developer.log('--> ${options.method} ${options.uri}', name: 'http');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    developer.log(
      '<-- ${response.statusCode} ${response.requestOptions.uri}',
      name: 'http',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log(
      '<-- ERROR ${err.response?.statusCode} ${err.requestOptions.uri} '
      '(${err.type.name})',
      name: 'http',
    );
    handler.next(err);
  }
}

/// Maps every [DioException] to a `Failure` stored in `DioException.error`,
/// so callers can unwrap it with `(e as DioException).error as Failure`.
class ErrorMappingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: mapDioException(err),
        stackTrace: err.stackTrace,
        message: err.message,
      ),
    );
  }
}
