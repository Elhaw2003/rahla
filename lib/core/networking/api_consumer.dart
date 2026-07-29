import 'package:dio/dio.dart';

abstract class ApiConsumer {
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Object? data,
    CancelToken? cancelToken,
  });
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
  });

  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
  });

  Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
  });

  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
  });
}
