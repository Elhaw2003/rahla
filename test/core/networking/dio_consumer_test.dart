import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:travel_app/core/errors/exceptions.dart';
import 'package:travel_app/core/networking/dio_consumer.dart';
import 'package:travel_app/core/networking/internet_checker/network_info.dart';

import 'dio_consumer_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>(), MockSpec<NetworkInfo>()])
void main() {
  late MockDio dio;
  late MockNetworkInfo networkInfo;
  late DioConsumer consumer;

  setUp(() {
    dio = MockDio();
    networkInfo = MockNetworkInfo();
    consumer = DioConsumer(dio: dio, networkInfo: networkInfo);
    when(networkInfo.isConnected).thenAnswer((_) async => true);
  });

  Response<dynamic> response(dynamic data) {
    return Response<dynamic>(
      requestOptions: RequestOptions(path: '/test'),
      statusCode: 200,
      data: data,
    );
  }

  group('DioConsumer successful requests', () {
    test('get returns response data', () async {
      when(
        dio.get(
          '/test',
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
          cancelToken: anyNamed('cancelToken'),
          options: anyNamed('options'),
        ),
      ).thenAnswer((_) async => response({'id': 1}));

      final result = await consumer.get(
        '/test',
        queryParameters: {'page': 1},
        data: 'request-data',
      );

      expect(result, {'id': 1});
      verify(
        dio.get(
          '/test',
          queryParameters: {'page': 1},
          data: 'request-data',
          cancelToken: null,
          options: null,
        ),
      ).called(1);
    });

    test('post returns response data', () async {
      when(
        dio.post(
          '/test',
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer((_) async => response({'created': true}));

      final result = await consumer.post('/test', data: {'name': 'Ali'});

      expect(result, {'created': true});
    });

    test('put returns response data', () async {
      when(
        dio.put(
          '/test',
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer((_) async => response({'updated': true}));

      final result = await consumer.put('/test', data: {'name': 'Omar'});

      expect(result, {'updated': true});
    });

    test('patch returns response data', () async {
      when(
        dio.patch(
          '/test',
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer((_) async => response({'patched': true}));

      final result = await consumer.patch('/test', data: {'name': 'Sara'});

      expect(result, {'patched': true});
    });

    test('delete returns response data', () async {
      when(
        dio.delete(
          '/test',
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          cancelToken: anyNamed('cancelToken'),
          options: anyNamed('options'),
        ),
      ).thenAnswer((_) async => response({'deleted': true}));

      final result = await consumer.delete('/test');

      expect(result, {'deleted': true});
    });
  });

  group('DioConsumer error handling', () {
    test('throws NetworkException when internet is unavailable', () async {
      when(networkInfo.isConnected).thenAnswer((_) async => false);

      await expectLater(
        consumer.get('/test'),
        throwsA(
          isA<NetworkException>().having(
            (error) => error.message,
            'message',
            'No Internet Connection',
          ),
        ),
      );
      verifyNever(dio.get(any));
    });

    test('maps Dio 404 response to NotFoundException', () async {
      when(
        dio.get(
          '/test',
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
          cancelToken: anyNamed('cancelToken'),
          options: anyNamed('options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 404,
            data: {'message': 'Not found'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      await expectLater(
        consumer.get('/test'),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('rethrows canceled GET request', () async {
      when(
        dio.get(
          '/test',
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
          cancelToken: anyNamed('cancelToken'),
          options: anyNamed('options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.cancel,
        ),
      );

      await expectLater(
        consumer.get('/test'),
        throwsA(
          isA<DioException>().having(
            (error) => error.type,
            'type',
            DioExceptionType.cancel,
          ),
        ),
      );
    });
  });
}
