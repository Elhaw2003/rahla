import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:travel_app/core/errors/exceptions.dart';
import 'package:travel_app/core/errors/failure.dart';
import 'package:travel_app/core/errors/failure_mapper.dart';
import 'package:travel_app/core/helper/cache/secure_storage_caching.dart';
import 'package:travel_app/core/networking/api_consumer.dart';
import 'package:travel_app/core/networking/end_points.dart';
import 'package:travel_app/features/user/auth/data/models/login_response_model.dart';
import 'package:travel_app/features/user/auth/data/models/register_request_model.dart';
import 'package:travel_app/features/user/auth/data/models/register_response_model.dart';

abstract class AuthRepo {
  Future<Either<Failure, LoginResponseModel>> login({
    required String email,
    required String password,
  });
  Future<Either<Failure, RegisterResponseModel>> register({
    required RegisterRequestModel request,
  });
}

class AuthRepoImpl implements AuthRepo {
  final ApiConsumer _apiConsumer;
  final SecureStorageCaching _secureStorage;

  const AuthRepoImpl({
    required this._apiConsumer,
    required this._secureStorage,
  });

  @override
  Future<Either<Failure, LoginResponseModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiConsumer.post(
        EndPoints.login,
        data: {'email': email, 'password': password},
      );
      final loginResponse = LoginResponseModel.fromJson(
        Map<String, dynamic>.from(response as Map),
      );

      final data = loginResponse.data;
      if (data != null) {
        final accessToken = data.accessToken;
        final refreshToken = data.refreshToken;
        final user = data.user;

        if (accessToken != null && accessToken.isNotEmpty) {
          await _secureStorage.saveAccessToken(accessToken);
        }
        if (refreshToken != null && refreshToken.isNotEmpty) {
          await _secureStorage.saveRefreshToken(refreshToken);
        }
        if (user != null) {
          await _secureStorage.saveUser(user.toJson());
        }
      }

      return Right(loginResponse);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RegisterResponseModel>> register({
    required RegisterRequestModel request,
  }) async {
    try {
      final Map<String, dynamic> data = request.toJson();
      if (request.profileImage != null && request.profileImage!.isNotEmpty) {
        data['profileImage'] = await MultipartFile.fromFile(
          request.profileImage!,
          filename: request.profileImage!.split('/').last,
        );
      }
      final formData = FormData.fromMap(data);
      final response = await _apiConsumer.post(
        EndPoints.register,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      final registerResponse = RegisterResponseModel.fromJson(
        Map<String, dynamic>.from(response as Map),
      );

      final accessToken = registerResponse.accessToken;
      final refreshToken = registerResponse.refreshToken;
      final user = registerResponse.user;

      if (accessToken != null && accessToken.isNotEmpty) {
        await _secureStorage.saveAccessToken(accessToken);
      }
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _secureStorage.saveRefreshToken(refreshToken);
      }
      if (user != null) {
        await _secureStorage.saveUser(user.toJson());
      }
      return Right(registerResponse);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
