import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/core/services/google_service.dart';
import 'package:travel_app/features/user/auth/data/models/change_password_request_model.dart';
import 'package:travel_app/features/user/auth/data/models/forgot_password_request_model.dart';
import 'package:travel_app/features/user/auth/data/models/register_request_model.dart';
import 'package:travel_app/features/user/auth/data/models/reset_password_request_model.dart';
import 'package:travel_app/features/user/auth/data/repo/auth_repo.dart';
import 'package:travel_app/features/user/auth/presentation/cubit/auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthRepo _authRepo;
  final GoogleService _googleService;

  AuthCubit({required AuthRepo authRepo, required GoogleService googleService})
    : _authRepo = authRepo,
      _googleService = googleService,
      super(const AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());
    final result = await _authRepo.login(email: email, password: password);
    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (success) => emit(LoginSuccess(loginResponse: success)),
    );
  }

  Future<void> register({required RegisterRequestModel request}) async {
    emit(const AuthLoading());
    final result = await _authRepo.register(request: request);
    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (success) => emit(RegisterSuccess(registerResponse: success)),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(const GoogleAuthLoading());
    try {
      final credential = await _googleService.signInWithGoogle();
      if (credential == null) {
        emit(const AuthInitial());
        return;
      }

      final idToken = await credential.user?.getIdToken();
      debugPrint('idToken: $idToken');
      if (idToken == null || idToken.isEmpty) {
        emit(const AuthFailure(message: 'خطأ في التسجيل بواسطة الجوجل'));
        return;
      }

      final result = await _authRepo.signInWithGoogle(idToken: idToken);
      debugPrint('result: $result');
      result.fold(
        (failure) => emit(AuthFailure(message: failure.message)),
        (success) => emit(GoogleLoginSuccess(loginResponse: success)),
      );
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> changePassword({
    required ChangePasswordRequestModel request,
  }) async {
    emit(const AuthLoading());
    final result = await _authRepo.changePassword(request: request);
    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (message) => emit(ChangePasswordSuccess(message: message)),
    );
  }

  Future<void> forgotPassword({required String email}) async {
    emit(const ForgotPasswordLoading());
    final result = await _authRepo.forgotPassword(
      request: ForgotPasswordRequestModel(email: email, isProtected: true),
    );
    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (message) => emit(ForgotPasswordSuccess(email: email, message: message)),
    );
  }

  Future<void> resetPassword({
    required ResetPasswordRequestModel request,
  }) async {
    emit(const ResetPasswordLoading());
    final result = await _authRepo.resetPassword(request: request);
    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (message) => emit(ResetPasswordSuccess(message: message)),
    );
  }

  Future<void> logout() async {
    emit(const LogoutLoading());
    try {
      await _googleService.signOut();
    } catch (_) {}

    final result = await _authRepo.logout();
    result.fold(
      (_) => emit(const LogoutSuccess(message: 'تم تسجيل الخروج')),
      (message) => emit(LogoutSuccess(message: message)),
    );
  }
}
