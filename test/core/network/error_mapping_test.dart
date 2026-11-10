import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_template/core/config/app_config.dart';
import 'package:flutter_template/core/error/failure.dart';
import 'package:flutter_template/core/network/dio_client.dart';
import 'package:flutter_template/core/network/error_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

/// Adapter that answers every request with a fixed outcome.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this._respond);

  final Future<ResponseBody> Function(RequestOptions options) _respond;
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    lastRequest = options;
    return _respond(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(int status, String body) => ResponseBody.fromString(
  body,
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

Dio _dio(_FakeAdapter adapter, {String? token}) => buildDio(
  config: const AppConfig(
    environment: Environment.dev,
    apiBaseUrl: 'https://test.invalid',
  ),
  readToken: () async => token,
  enableLogging: false,
)..httpClientAdapter = adapter;

Future<Failure> _failureOf(Dio dio) async {
  try {
    await dio.get<dynamic>('/x');
  } on DioException catch (e) {
    return e.error! as Failure;
  }
  fail('Expected a DioException');
}

void main() {
  group('mapDioException', () {
    final options = RequestOptions(path: '/x');

    test('maps timeouts to TimeoutFailure', () {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ]) {
        expect(
          mapDioException(DioException(requestOptions: options, type: type)),
          isA<TimeoutFailure>(),
        );
      }
    });

    test('maps connection errors to NetworkFailure', () {
      final e = DioException.connectionError(
        requestOptions: options,
        reason: 'offline',
      );
      expect(mapDioException(e), isA<NetworkFailure>());
    });

    test('maps 401 and 404 to dedicated failures', () {
      Failure forStatus(int code) => mapDioException(
        DioException.badResponse(
          statusCode: code,
          requestOptions: options,
          response: Response<dynamic>(
            requestOptions: options,
            statusCode: code,
          ),
        ),
      );

      expect(forStatus(401), isA<UnauthorizedFailure>());
      expect(forStatus(404), isA<NotFoundFailure>());
    });

    test('maps 5xx to ServerFailure with status and server message', () {
      final failure = mapDioException(
        DioException.badResponse(
          statusCode: 503,
          requestOptions: options,
          response: Response<dynamic>(
            requestOptions: options,
            statusCode: 503,
            data: <String, dynamic>{'message': 'Maintenance'},
          ),
        ),
      );

      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).statusCode, 503);
      expect(failure.message, 'Maintenance');
    });

    test('maps anything else to UnknownFailure', () {
      final e = DioException(requestOptions: options, message: 'boom');
      expect(mapDioException(e), isA<UnknownFailure>());
    });
  });

  group('interceptor stack', () {
    test('rejects 401 responses with an UnauthorizedFailure', () async {
      final dio = _dio(_FakeAdapter((_) async => _json(401, '{}')));

      expect(await _failureOf(dio), isA<UnauthorizedFailure>());
    });

    test('rejects 500 responses with a ServerFailure', () async {
      final dio = _dio(
        _FakeAdapter((_) async => _json(500, '{"error":"db down"}')),
      );

      final failure = await _failureOf(dio);
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'db down');
    });

    test('attaches the bearer token when one is stored', () async {
      final adapter = _FakeAdapter((_) async => _json(200, '{}'));
      final dio = _dio(adapter, token: 'abc');

      await dio.get<dynamic>('/x');

      expect(adapter.lastRequest!.headers['Authorization'], 'Bearer abc');
    });

    test('omits the Authorization header when signed out', () async {
      final adapter = _FakeAdapter((_) async => _json(200, '{}'));
      final dio = _dio(adapter);

      await dio.get<dynamic>('/x');

      expect(adapter.lastRequest!.headers, isNot(contains('Authorization')));
    });
  });
}
