import 'package:dio/dio.dart';
import 'package:travel_app/core/helper/cache/secure_storage_caching.dart';

class ApiInterceptor extends Interceptor {
  final SecureStorageCaching secureStorage;

  ApiInterceptor(this.secureStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    secureStorage
        .getToken()
        .then((token) {
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        })
        .catchError((_) {
          handler.next(options);
        });
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
