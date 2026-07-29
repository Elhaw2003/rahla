import 'dart:async';

import 'package:dio/dio.dart';
import 'package:travel_app/core/helper/cache/secure_storage_caching.dart';
import 'package:travel_app/core/networking/end_points.dart';

class ApiInterceptor extends Interceptor {
  final SecureStorageCaching secureStorage;
  final Dio dio;

  Completer<bool>? _refreshCompleter;

  ApiInterceptor({
    required this.secureStorage,
    required this.dio,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept-Language'] = 'ar';

    final token = await secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final isRefreshCall =
        err.requestOptions.path.contains(EndPoints.refreshToken);

    if (!isUnauthorized || isRefreshCall) {
      handler.next(err);
      return;
    }

    try {
      final refreshed = await _refreshTokens();
      if (!refreshed) {
        await secureStorage.clearAuthData();
        handler.next(err);
        return;
      }

      final accessToken = await secureStorage.getAccessToken();
      err.requestOptions.headers['Authorization'] = 'Bearer $accessToken';

      final response = await dio.fetch(err.requestOptions);
      handler.resolve(response);
    } catch (_) {
      await secureStorage.clearAuthData();
      handler.next(err);
    }
  }

  Future<bool> _refreshTokens() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();

    try {
      final refreshToken = await secureStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        _refreshCompleter!.complete(false);
        return false;
      }

      // Dio بدون interceptor عشان مفيش loop
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: EndPoints.baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept-Language': 'ar',
          },
        ),
      );

      final response = await refreshDio.post(
        EndPoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      final data = response.data['data'] as Map?;
      final accessToken = data?['accessToken']?.toString();
      final newRefreshToken = data?['refreshToken']?.toString();

      if (accessToken == null ||
          accessToken.isEmpty ||
          newRefreshToken == null ||
          newRefreshToken.isEmpty) {
        _refreshCompleter!.complete(false);
        return false;
      }

      await secureStorage.saveAccessToken(accessToken);
      await secureStorage.saveRefreshToken(newRefreshToken);

      _refreshCompleter!.complete(true);
      return true;
    } catch (_) {
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }
}
