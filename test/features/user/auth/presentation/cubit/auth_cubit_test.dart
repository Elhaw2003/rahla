import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:travel_app/core/errors/failure.dart' as app_failure;
import 'package:travel_app/core/services/google_service.dart';
import 'package:travel_app/features/user/auth/data/models/change_password_request_model.dart';
import 'package:travel_app/features/user/auth/data/models/login_response_model.dart';
import 'package:travel_app/features/user/auth/data/models/register_request_model.dart';
import 'package:travel_app/features/user/auth/data/models/register_response_model.dart';
import 'package:travel_app/features/user/auth/data/models/reset_password_request_model.dart';
import 'package:travel_app/features/user/auth/data/repo/auth_repo.dart';
import 'package:travel_app/features/user/auth/presentation/cubit/auth_cubit.dart';
import 'package:travel_app/features/user/auth/presentation/cubit/auth_states.dart';

import 'auth_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthRepo>(),
  MockSpec<GoogleService>(),
  MockSpec<UserCredential>(),
  MockSpec<User>(),
])
void main() {
  late MockAuthRepo authRepo;
  late MockGoogleService googleService;

  AuthCubit buildCubit() =>
      AuthCubit(authRepo: authRepo, googleService: googleService);

  const loginResponse = LoginResponseModel(
    statusCode: 200,
    success: true,
    code: 'LOGIN_SUCCESS',
    message: 'Welcome',
  );
  const registerResponse = RegisterResponseModel(
    statusCode: 201,
    success: true,
    code: 'REGISTER_SUCCESS',
    message: 'Account created',
  );

  setUp(() {
    authRepo = MockAuthRepo();
    googleService = MockGoogleService();
  });

  blocTest<AuthCubit, AuthStates>(
    'login emits loading then success',
    build: buildCubit,
    setUp: () {
      when(
        authRepo.login(email: 'user@example.com', password: 'secret'),
      ).thenAnswer((_) async => const Right(loginResponse));
    },
    act: (cubit) => cubit.login(email: 'user@example.com', password: 'secret'),
    expect: () => [
      const AuthLoading(),
      const LoginSuccess(loginResponse: loginResponse),
    ],
    verify: (_) {
      verify(
        authRepo.login(email: 'user@example.com', password: 'secret'),
      ).called(1);
    },
  );

  blocTest<AuthCubit, AuthStates>(
    'login emits the repository failure',
    build: buildCubit,
    setUp: () {
      when(
        authRepo.login(email: 'user@example.com', password: 'wrong'),
      ).thenAnswer(
        (_) async => const Left(app_failure.AuthFailure('Invalid credentials')),
      );
    },
    act: (cubit) => cubit.login(email: 'user@example.com', password: 'wrong'),
    expect: () => [
      const AuthLoading(),
      const AuthFailure(message: 'Invalid credentials'),
    ],
  );

  blocTest<AuthCubit, AuthStates>(
    'register emits loading then success',
    build: buildCubit,
    setUp: () {
      when(
        authRepo.register(
          request: const RegisterRequestModel(email: 'user@example.com'),
        ),
      ).thenAnswer((_) async => const Right(registerResponse));
    },
    act: (cubit) => cubit.register(
      request: const RegisterRequestModel(email: 'user@example.com'),
    ),
    expect: () => [
      const AuthLoading(),
      const RegisterSuccess(registerResponse: registerResponse),
    ],
  );

  blocTest<AuthCubit, AuthStates>(
    'Google sign-in cancellation returns to the initial state',
    build: buildCubit,
    setUp: () {
      when(googleService.signInWithGoogle()).thenAnswer((_) async => null);
    },
    act: (cubit) => cubit.signInWithGoogle(),
    expect: () => [const GoogleAuthLoading(), const AuthInitial()],
    verify: (_) {
      verifyNever(authRepo.signInWithGoogle(idToken: anyNamed('idToken')));
    },
  );

  blocTest<AuthCubit, AuthStates>(
    'Google sign-in exchanges the Firebase ID token for an app session',
    build: buildCubit,
    setUp: () {
      final credential = MockUserCredential();
      final user = MockUser();
      when(
        googleService.signInWithGoogle(),
      ).thenAnswer((_) async => credential);
      when(credential.user).thenReturn(user);
      when(user.getIdToken()).thenAnswer((_) async => 'firebase-id-token');
      when(
        authRepo.signInWithGoogle(idToken: 'firebase-id-token'),
      ).thenAnswer((_) async => const Right(loginResponse));
    },
    act: (cubit) => cubit.signInWithGoogle(),
    expect: () => [
      const GoogleAuthLoading(),
      const GoogleLoginSuccess(loginResponse: loginResponse),
    ],
    verify: (_) {
      verify(authRepo.signInWithGoogle(idToken: 'firebase-id-token')).called(1);
    },
  );

  blocTest<AuthCubit, AuthStates>(
    'Google sign-in emits a failure when the authentication service throws',
    build: buildCubit,
    setUp: () {
      when(
        googleService.signInWithGoogle(),
      ).thenThrow(Exception('Google error'));
    },
    act: (cubit) => cubit.signInWithGoogle(),
    expect: () => [
      const GoogleAuthLoading(),
      isA<AuthFailure>().having(
        (state) => state.message,
        'message',
        contains('Google error'),
      ),
    ],
  );

  blocTest<AuthCubit, AuthStates>(
    'changePassword emits loading then success',
    build: buildCubit,
    setUp: () {
      when(
        authRepo.changePassword(
          request: const ChangePasswordRequestModel(
            currentPassword: 'old',
            newPassword: 'new',
            confirmNewPassword: 'new',
          ),
        ),
      ).thenAnswer((_) async => const Right('Password changed'));
    },
    act: (cubit) => cubit.changePassword(
      request: const ChangePasswordRequestModel(
        currentPassword: 'old',
        newPassword: 'new',
        confirmNewPassword: 'new',
      ),
    ),
    expect: () => [
      const AuthLoading(),
      const ChangePasswordSuccess(message: 'Password changed'),
    ],
  );

  blocTest<AuthCubit, AuthStates>(
    'forgotPassword emits loading then success with the requested email',
    build: buildCubit,
    setUp: () {
      when(
        authRepo.forgotPassword(request: anyNamed('request')),
      ).thenAnswer((_) async => const Right('Verification code sent'));
    },
    act: (cubit) => cubit.forgotPassword(email: 'user@example.com'),
    expect: () => [
      const ForgotPasswordLoading(),
      const ForgotPasswordSuccess(
        email: 'user@example.com',
        message: 'Verification code sent',
      ),
    ],
  );

  blocTest<AuthCubit, AuthStates>(
    'resetPassword emits loading then success',
    build: buildCubit,
    setUp: () {
      when(
        authRepo.resetPassword(
          request: const ResetPasswordRequestModel(
            email: 'user@example.com',
            otp: '123456',
            newPassword: 'new',
            confirmNewPassword: 'new',
          ),
        ),
      ).thenAnswer((_) async => const Right('Password reset'));
    },
    act: (cubit) => cubit.resetPassword(
      request: const ResetPasswordRequestModel(
        email: 'user@example.com',
        otp: '123456',
        newPassword: 'new',
        confirmNewPassword: 'new',
      ),
    ),
    expect: () => [
      const ResetPasswordLoading(),
      const ResetPasswordSuccess(message: 'Password reset'),
    ],
  );

  blocTest<AuthCubit, AuthStates>(
    'logout reports success even when remote logout fails',
    build: buildCubit,
    setUp: () {
      when(
        googleService.signOut(),
      ).thenThrow(Exception('Google sign-out error'));
      when(authRepo.logout()).thenAnswer(
        (_) async => const Left(app_failure.NetworkFailure('Offline')),
      );
    },
    act: (cubit) => cubit.logout(),
    expect: () => [
      const LogoutLoading(),
      const LogoutSuccess(message: 'تم تسجيل الخروج'),
    ],
    verify: (_) {
      verify(authRepo.logout()).called(1);
    },
  );

  blocTest<AuthCubit, AuthStates>(
    'logout emits the repository message on success',
    build: buildCubit,
    setUp: () {
      when(googleService.signOut()).thenAnswer((_) async {});
      when(
        authRepo.logout(),
      ).thenAnswer((_) async => const Right('Signed out'));
    },
    act: (cubit) => cubit.logout(),
    expect: () => [
      const LogoutLoading(),
      const LogoutSuccess(message: 'Signed out'),
    ],
  );
}
