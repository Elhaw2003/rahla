import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/core/errors/dio_exceptions.dart';
import 'package:travel_app/core/errors/exceptions.dart';

void main() {
  group('DioExceptionHandler', () {
    test('maps timeout and connection errors to NetworkException', () {
      expect(
        () => DioExceptionHandler.handle(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.connectionTimeout,
          ),
        ),
        throwsA(isA<NetworkException>()),
      );
      expect(
        () => DioExceptionHandler.handle(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.connectionError,
            error: const SocketException('offline'),
          ),
        ),
        throwsA(isA<NetworkException>()),
      );
    });

    test('maps bad responses to the matching exception family', () {
      DioException badResponse(int statusCode) {
        return DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: statusCode,
            data: {'message': 'API error', 'code': 'API_ERROR'},
          ),
          type: DioExceptionType.badResponse,
        );
      }

      expect(
        () => DioExceptionHandler.handle(badResponse(400)),
        throwsA(isA<ValidationException>()),
      );
      expect(
        () => DioExceptionHandler.handle(badResponse(401)),
        throwsA(isA<AuthException>()),
      );
      expect(
        () => DioExceptionHandler.handle(badResponse(403)),
        throwsA(isA<PermissionException>()),
      );
      expect(
        () => DioExceptionHandler.handle(badResponse(404)),
        throwsA(isA<NotFoundException>()),
      );
      expect(
        () => DioExceptionHandler.handle(badResponse(422)),
        throwsA(isA<ValidationException>()),
      );
      expect(
        () => DioExceptionHandler.handle(badResponse(500)),
        throwsA(isA<ServerException>()),
      );
    });

    test('maps cancel and unknown errors', () {
      expect(
        () => DioExceptionHandler.handle(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.cancel,
          ),
        ),
        throwsA(isA<ServerException>()),
      );
      expect(
        () => DioExceptionHandler.handle(
          DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.unknown,
          ),
        ),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
