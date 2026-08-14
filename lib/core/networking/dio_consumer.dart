import 'package:dio/dio.dart';
import 'package:travel_app/core/errors/dio_exceptions.dart';
import 'package:travel_app/core/errors/exceptions.dart';
import 'package:travel_app/core/networking/api_consumer.dart';
import 'package:travel_app/core/networking/internet_checker/network_info.dart';

class DioConsumer implements ApiConsumer {
  final Dio dio;
  final NetworkInfo networkInfo;

  DioConsumer({required this.dio, required this.networkInfo});
  @override
  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Object? data,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      await _checkInternet();
      final response = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      DioExceptionHandler.handle(e);
    }
  }

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Object? data,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    try {
      await _checkInternet();
      final response = await dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        rethrow;
      }
      DioExceptionHandler.handle(e);
    }
  }

  @override
  Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? queryParameters,
    data,
    Options? options,
  }) async {
    try {
      await _checkInternet();
      final response = await dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      DioExceptionHandler.handle(e);
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? queryParameters,
    data,
    Options? options,
  }) async {
    try {
      await _checkInternet();
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      DioExceptionHandler.handle(e);
    }
  }

  @override
  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? queryParameters,
    data,
    Options? options,
  }) async {
    try {
      await _checkInternet();
      final response = await dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      DioExceptionHandler.handle(e);
    }
  }

  Future<void> _checkInternet() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('No Internet Connection');
    }
  }
}
