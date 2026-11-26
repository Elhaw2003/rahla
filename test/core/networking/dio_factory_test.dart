import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:travel_app/core/helper/cache/secure_storage_caching.dart';
import 'package:travel_app/core/networking/api_interceptor.dart';
import 'package:travel_app/core/networking/dio_factory.dart';
import 'package:travel_app/core/networking/end_points.dart';

import '../helper/secure_storage_caching_test.mocks.dart';

void main() {
  test('configures Dio defaults and attaches the auth interceptor', () {
    final secureStorage = SecureStorageCaching(MockFlutterSecureStorage());

    final dio = DioFactory.createDio(secureStorage);

    expect(dio.options.baseUrl, EndPoints.baseUrl);
    expect(dio.options.connectTimeout, const Duration(seconds: 30));
    expect(dio.options.receiveTimeout, const Duration(seconds: 30));
    expect(dio.options.sendTimeout, const Duration(seconds: 30));
    expect(dio.options.headers['Content-Type'], 'application/json');
    expect(dio.options.headers['Accept'], 'application/json');

    final authInterceptor = dio.interceptors.whereType<ApiInterceptor>();
    expect(authInterceptor, hasLength(1));
    expect(authInterceptor.single.secureStorage, same(secureStorage));
    expect(authInterceptor.single.dio, same(dio));
  });

  test('adds Dio logger only in debug mode', () {
    final secureStorage = SecureStorageCaching(MockFlutterSecureStorage());

    final dio = DioFactory.createDio(secureStorage);

    expect(
      dio.interceptors.whereType<PrettyDioLogger>().isNotEmpty,
      kDebugMode,
    );
  });
}
