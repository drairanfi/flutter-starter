import 'package:dio/dio.dart';
import 'package:flutter_template/core/error/failure.dart';

/// Converts any [DioException] into the app's sealed [Failure] hierarchy.
Failure mapDioException(DioException exception) {
  // Already mapped by the error interceptor.
  final inner = exception.error;
  if (inner is Failure) return inner;

  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return TimeoutFailure(exception.message);
    case DioExceptionType.connectionError:
      return NetworkFailure(exception.message);
    case DioExceptionType.badResponse:
      return _fromStatus(exception.response);
    case DioExceptionType.cancel:
      return const UnknownFailure('Request cancelled');
    case DioExceptionType.badCertificate:
      return const NetworkFailure('Bad certificate');
    case DioExceptionType.unknown:
      return UnknownFailure(exception.message ?? inner?.toString());
  }
}

Failure _fromStatus(Response<dynamic>? response) {
  final status = response?.statusCode;
  final message = _extractMessage(response?.data);
  return switch (status) {
    401 => UnauthorizedFailure(message),
    404 => NotFoundFailure(message),
    _ => ServerFailure(statusCode: status, message: message),
  };
}

String? _extractMessage(dynamic data) {
  if (data is Map<String, dynamic>) {
    final value = data['message'] ?? data['error'];
    if (value is String) return value;
  }
  return null;
}
