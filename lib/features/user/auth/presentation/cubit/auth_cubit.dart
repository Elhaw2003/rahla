import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/core/services/google_service.dart';
import 'package:travel_app/features/user/auth/data/models/register_request_model.dart';
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
    emit(const AuthLoading());
    try {
      final credential = await _googleService.signInWithGoogle();
      if (credential == null) {
        emit(const AuthInitial());
        return;
      }

      final idToken = await credential.user?.getIdToken();
      print('idToken: $idToken');
      if (idToken == null || idToken.isEmpty) {
        emit(const AuthFailure(message: 'خطأ في التسجيل بواسطة الجوجل'));
        return;
      }

      final result = await _authRepo.signInWithGoogle(idToken: idToken);
      result.fold(
        (failure) => emit(AuthFailure(message: failure.message)),
        (success) => emit(GoogleLoginSuccess(loginResponse: success)),
      );
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }
}
