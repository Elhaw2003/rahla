import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:travel_app/core/errors/exceptions.dart';
import 'package:travel_app/core/errors/failure.dart';
import 'package:travel_app/core/helper/cache/secure_storage_caching.dart';
import 'package:travel_app/core/networking/api_consumer.dart';
import 'package:travel_app/core/networking/end_points.dart';
import 'package:travel_app/features/user/auth/data/models/change_password_request_model.dart';
import 'package:travel_app/features/user/auth/data/models/forgot_password_request_model.dart';
import 'package:travel_app/features/user/auth/data/models/register_request_model.dart';
import 'package:travel_app/features/user/auth/data/models/reset_password_request_model.dart';
import 'package:travel_app/features/user/auth/data/models/update_profile_request_model.dart';
import 'package:travel_app/features/user/auth/data/repo/auth_repo.dart';

import 'auth_repo_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ApiConsumer>(), MockSpec<SecureStorageCaching>()])
void main() {
  late MockApiConsumer apiConsumer;
  late MockSecureStorageCaching secureStorage;
  late AuthRepoImpl authRepo;

  setUp(() {
    apiConsumer = MockApiConsumer();
    secureStorage = MockSecureStorageCaching();
    authRepo = AuthRepoImpl(
      apiConsumer: apiConsumer,
      secureStorage: secureStorage,
    );
  });

  group('login', () {
    test('parses the response and persists returned credentials', () async {
      when(
        apiConsumer.post(
          any,
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => {
          'statusCode': 200,
          'success': true,
          'code': 'LOGIN_SUCCESS',
          'message': 'Welcome',
          'data': {
            'accessToken': 'access-token',
            'refreshToken': 'refresh-token',
            'user': {'_id': 'user-1', 'email': 'user@example.com'},
          },
        },
      );

      final result = await authRepo.login(
        email: 'user@example.com',
        password: 'secret',
      );

      expect(result, isA<Right<Failure, dynamic>>());
      final response = result.getOrElse(
        () => throw StateError('Expected login to succeed'),
      );
      expect(response.message, 'Welcome');
      expect(response.data?.accessToken, 'access-token');
      verify(
        apiConsumer.post(
          EndPoints.login,
          queryParameters: null,
          data: {'email': 'user@example.com', 'password': 'secret'},
          options: null,
        ),
      ).called(1);
      verify(secureStorage.saveAccessToken('access-token')).called(1);
      verify(secureStorage.saveRefreshToken('refresh-token')).called(1);
      verify(
        secureStorage.saveUser({
          '_id': 'user-1',
          'fullName': null,
          'email': 'user@example.com',
          'phone': null,
          'profileImage': null,
          'authProvider': null,
          'role': null,
          'createdAt': null,
          'updatedAt': null,
          '__v': null,
          'fcmTokens': const <String>[],
          'isProtected': false,
        }),
      ).called(1);
    });

    test('maps authentication exceptions to failures', () async {
      when(
        apiConsumer.post(
          any,
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenThrow(AuthException('Invalid credentials', 'AUTH'));

      final result = await authRepo.login(
        email: 'user@example.com',
        password: 'wrong',
      );

      expect(
        result.fold((failure) => failure, (_) => null),
        isA<AuthFailure>()
            .having(
              (failure) => failure.message,
              'message',
              'Invalid credentials',
            )
            .having((failure) => failure.code, 'code', 'AUTH'),
      );
      verifyNever(secureStorage.saveAccessToken(any));
    });
  });

  test(
    'register sends multipart data and persists returned credentials',
    () async {
      when(
        apiConsumer.post(
          any,
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => {
          'statusCode': 201,
          'success': true,
          'code': 'REGISTER_SUCCESS',
          'message': 'Account created',
          'data': {
            'accessToken': 'access-token',
            'refreshToken': 'refresh-token',
            'user': {'_id': 'user-1'},
          },
        },
      );

      final result = await authRepo.register(
        request: const RegisterRequestModel(email: 'user@example.com'),
      );

      expect(result.isRight(), isTrue);
      expect(
        result
            .getOrElse(
              () => throw StateError('Expected registration to succeed'),
            )
            .message,
        'Account created',
      );
      verify(
        apiConsumer.post(
          EndPoints.register,
          queryParameters: null,
          data: argThat(isA<FormData>(), named: 'data'),
          options: argThat(
            isA<Options>().having(
              (options) => options.contentType,
              'contentType',
              'multipart/form-data',
            ),
            named: 'options',
          ),
        ),
      ).called(1);
      verify(secureStorage.saveAccessToken('access-token')).called(1);
      verify(secureStorage.saveRefreshToken('refresh-token')).called(1);
      verify(secureStorage.saveUser(any)).called(1);
    },
  );

  test('Google login sends the ID token and parses the response', () async {
    when(
      apiConsumer.post(
        any,
        queryParameters: anyNamed('queryParameters'),
        data: anyNamed('data'),
        options: anyNamed('options'),
      ),
    ).thenAnswer(
      (_) async => {
        'statusCode': 200,
        'success': true,
        'code': 'LOGIN_SUCCESS',
        'message': 'Welcome',
        'data': {'accessToken': 'google-access-token'},
      },
    );

    final result = await authRepo.signInWithGoogle(idToken: 'google-id-token');

    expect(result.isRight(), isTrue);
    expect(
      result
          .getOrElse(() => throw StateError('Expected Google login to succeed'))
          .data
          ?.accessToken,
      'google-access-token',
    );
    verify(
      apiConsumer.post(
        EndPoints.googleLogin,
        queryParameters: null,
        data: {'idToken': 'google-id-token'},
        options: null,
      ),
    ).called(1);
    verify(secureStorage.saveAccessToken('google-access-token')).called(1);
  });

  test('registerFcmToken sends the token', () async {
    when(
      apiConsumer.patch(
        any,
        queryParameters: anyNamed('queryParameters'),
        data: anyNamed('data'),
        options: anyNamed('options'),
      ),
    ).thenAnswer((_) async => {});

    final result = await authRepo.registerFcmToken(fcmToken: 'fcm-token');

    expect(result, const Right<Failure, void>(null));
    verify(
      apiConsumer.patch(
        EndPoints.registerFcmToken,
        queryParameters: null,
        data: {'fcmToken': 'fcm-token'},
        options: null,
      ),
    ).called(1);
  });

  group('getUserProfile', () {
    test('parses the profile and caches it', () async {
      when(
        apiConsumer.get(
          any,
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
          cancelToken: anyNamed('cancelToken'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => {
          'statusCode': 200,
          'success': true,
          'code': 'OK',
          'message': 'Profile',
          'data': {'_id': 'user-1', 'email': 'user@example.com'},
        },
      );

      final result = await authRepo.getUserProfile();

      expect(result.isRight(), isTrue);
      expect(
        result.getOrElse(() => throw StateError('Expected profile to load')).id,
        'user-1',
      );
      verify(apiConsumer.get(EndPoints.getUserProfile)).called(1);
      verify(secureStorage.saveUser(any)).called(1);
    });

    test('returns a failure when the response has no profile data', () async {
      when(
        apiConsumer.get(
          any,
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
          cancelToken: anyNamed('cancelToken'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => {'statusCode': 200, 'success': true, 'data': null},
      );

      final result = await authRepo.getUserProfile();

      expect(
        result.fold((failure) => failure, (_) => null),
        isA<UnexpectedFailure>().having(
          (failure) => failure.message,
          'message',
          'User profile data is missing',
        ),
      );
      verifyNever(secureStorage.saveUser(any));
    });
  });

  group('updateProfile', () {
    test('does not send an empty update', () async {
      final result = await authRepo.updateProfile(
        request: const UpdateProfileRequestModel(),
      );

      expect(
        result.fold((failure) => failure, (_) => null),
        isA<UnexpectedFailure>().having(
          (failure) => failure.message,
          'message',
          'No changes to update',
        ),
      );
      verifyNever(
        apiConsumer.put(
          any,
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      );
    });

    test('sends changes and caches the updated profile', () async {
      when(
        apiConsumer.put(
          any,
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => {
          'statusCode': 200,
          'success': true,
          'data': {'_id': 'user-1', 'fullName': 'New Name'},
        },
      );

      final result = await authRepo.updateProfile(
        request: const UpdateProfileRequestModel(fullName: 'New Name'),
      );

      expect(result.isRight(), isTrue);
      expect(
        result
            .getOrElse(
              () => throw StateError('Expected profile update to succeed'),
            )
            .fullName,
        'New Name',
      );
      verify(
        apiConsumer.put(
          EndPoints.updateProfile,
          queryParameters: null,
          data: argThat(isA<FormData>(), named: 'data'),
          options: argThat(isA<Options>(), named: 'options'),
        ),
      ).called(1);
      verify(secureStorage.saveUser(any)).called(1);
    });
  });

  test('changePassword sends the request and returns its message', () async {
    when(
      apiConsumer.patch(
        any,
        queryParameters: anyNamed('queryParameters'),
        data: anyNamed('data'),
        options: anyNamed('options'),
      ),
    ).thenAnswer((_) async => {'message': 'Password changed'});

    final result = await authRepo.changePassword(
      request: const ChangePasswordRequestModel(
        currentPassword: 'old',
        newPassword: 'new',
        confirmNewPassword: 'new',
      ),
    );

    expect(result, const Right<Failure, String>('Password changed'));
    verify(
      apiConsumer.patch(
        EndPoints.changePassword,
        queryParameters: null,
        data: {
          'currentPassword': 'old',
          'newPassword': 'new',
          'confirmPassword': 'new',
        },
        options: null,
      ),
    ).called(1);
  });

  test('forgotPassword sends the request and returns its message', () async {
    when(
      apiConsumer.post(
        any,
        queryParameters: anyNamed('queryParameters'),
        data: anyNamed('data'),
        options: anyNamed('options'),
      ),
    ).thenAnswer((_) async => {'message': 'OTP sent'});

    final result = await authRepo.forgotPassword(
      request: const ForgotPasswordRequestModel(email: 'user@example.com'),
    );

    expect(result, const Right<Failure, String>('OTP sent'));
    verify(
      apiConsumer.post(
        EndPoints.forgotPassword,
        queryParameters: null,
        data: {'email': 'user@example.com', 'isProtected': true},
        options: null,
      ),
    ).called(1);
  });

  test('resetPassword sends the request and returns its message', () async {
    when(
      apiConsumer.post(
        any,
        queryParameters: anyNamed('queryParameters'),
        data: anyNamed('data'),
        options: anyNamed('options'),
      ),
    ).thenAnswer((_) async => {'message': 'Password reset'});

    final result = await authRepo.resetPassword(
      request: const ResetPasswordRequestModel(
        email: 'user@example.com',
        otp: '123456',
        newPassword: 'new-secret',
        confirmNewPassword: 'new-secret',
      ),
    );

    expect(result, const Right<Failure, String>('Password reset'));
    verify(
      apiConsumer.post(
        EndPoints.resetPassword,
        queryParameters: null,
        data: {
          'email': 'user@example.com',
          'otp': '123456',
          'newPassword': 'new-secret',
          'confirmPassword': 'new-secret',
          'isProtected': true,
        },
        options: null,
      ),
    ).called(1);
  });

  test('logout clears credentials and returns the server message', () async {
    when(
      apiConsumer.post(
        any,
        queryParameters: anyNamed('queryParameters'),
        data: anyNamed('data'),
        options: anyNamed('options'),
      ),
    ).thenAnswer((_) async => {'message': 'Signed out'});

    final result = await authRepo.logout();

    expect(result, const Right<Failure, String>('Signed out'));
    verify(apiConsumer.post(EndPoints.logout)).called(1);
    verify(secureStorage.clearAuthData()).called(1);
  });

  test(
    'logout clears locally stored credentials if the request fails',
    () async {
      when(
        apiConsumer.post(
          any,
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenThrow(NetworkException('Offline'));

      final result = await authRepo.logout();

      expect(
        result.fold((failure) => failure, (_) => null),
        isA<NetworkFailure>(),
      );
      verify(secureStorage.clearAuthData()).called(1);
    },
  );
}
