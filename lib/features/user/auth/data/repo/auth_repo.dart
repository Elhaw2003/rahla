import 'package:dartz/dartz.dart';
import 'package:travel_app/core/errors/exceptions.dart';
import 'package:travel_app/core/errors/failure.dart';
import 'package:travel_app/core/errors/failure_mapper.dart';
import 'package:travel_app/core/helper/cache/secure_storage_caching.dart';
import 'package:travel_app/core/networking/api_consumer.dart';
import 'package:travel_app/core/networking/end_points.dart';
import 'package:travel_app/features/user/auth/data/models/login_response_model.dart';

abstract class AuthRepo {
  Future<Either<Failure, LoginResponseModel>> login({
    required String email,
    required String password,
  });
}

class AuthRepoImpl implements AuthRepo {
  final ApiConsumer _apiConsumer;
  final SecureStorageCaching _secureStorage;

  const AuthRepoImpl({
    required ApiConsumer apiConsumer,
    required SecureStorageCaching secureStorage,
  }) : _apiConsumer = apiConsumer,
       _secureStorage = secureStorage;

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
}
