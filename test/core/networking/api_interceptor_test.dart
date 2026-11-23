import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:travel_app/core/helper/cache/secure_storage_caching.dart';
import 'package:travel_app/core/networking/api_interceptor.dart';

import 'api_interceptor_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SecureStorageCaching>(),
  MockSpec<Dio>(),
  MockSpec<RequestInterceptorHandler>(),
  MockSpec<ErrorInterceptorHandler>(),
])
void main() {
  late MockSecureStorageCaching secureStorage;
  late MockDio dio;
  late ApiInterceptor interceptor;

  setUp(() {
    secureStorage = MockSecureStorageCaching();
    dio = MockDio();
    interceptor = ApiInterceptor(secureStorage: secureStorage, dio: dio);
  });

  group('onRequest', () {
    test('adds bearer authorization when access token exists', () async {
      when(
        secureStorage.getAccessToken(),
      ).thenAnswer((_) async => 'test-access-token');
      final handler = MockRequestInterceptorHandler();
      final options = RequestOptions(path: '/profile');

      interceptor.onRequest(options, handler);
      await pumpEventQueue();

      expect(options.headers['Authorization'], 'Bearer test-access-token');
      expect(options.headers['Content-Type'], 'application/json');
      expect(options.headers['Accept-Language'], 'ar');
      verify(handler.next(options)).called(1);
    });

    test('does not add authorization when access token is empty', () async {
      when(secureStorage.getAccessToken()).thenAnswer((_) async => '');
      final handler = MockRequestInterceptorHandler();
      final options = RequestOptions(path: '/profile');

      interceptor.onRequest(options, handler);
      await pumpEventQueue();

      expect(options.headers.containsKey('Authorization'), isFalse);
      verify(handler.next(options)).called(1);
    });
  });

  group('onError', () {
    test('passes non-401 errors through without refreshing', () async {
      final handler = MockErrorInterceptorHandler();
      final error = DioException(
        requestOptions: RequestOptions(path: '/profile'),
        response: Response(
          requestOptions: RequestOptions(path: '/profile'),
          statusCode: 500,
        ),
        type: DioExceptionType.badResponse,
      );

      interceptor.onError(error, handler);
      await pumpEventQueue();

      verify(handler.next(error)).called(1);
      verifyNever(secureStorage.clearAuthData());
      verifyNever(secureStorage.getRefreshToken());
    });

    test('passes refresh endpoint 401 errors through', () async {
      final handler = MockErrorInterceptorHandler();
      final error = DioException(
        requestOptions: RequestOptions(path: '/auth/refresh-token'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/refresh-token'),
          statusCode: 401,
        ),
        type: DioExceptionType.badResponse,
      );

      interceptor.onError(error, handler);
      await pumpEventQueue();

      verify(handler.next(error)).called(1);
      verifyNever(secureStorage.clearAuthData());
    });

    test(
      'clears auth data and passes error through when refresh token is missing',
      () async {
        when(secureStorage.getRefreshToken()).thenAnswer((_) async => null);
        when(secureStorage.clearAuthData()).thenAnswer((_) async {});

        final handler = MockErrorInterceptorHandler();
        final error = DioException(
          requestOptions: RequestOptions(path: '/profile'),
          response: Response(
            requestOptions: RequestOptions(path: '/profile'),
            statusCode: 401,
          ),
          type: DioExceptionType.badResponse,
        );

        interceptor.onError(error, handler);
        await pumpEventQueue();

        verify(secureStorage.clearAuthData()).called(1);
        verify(handler.next(error)).called(1);
      },
    );
  });
}
