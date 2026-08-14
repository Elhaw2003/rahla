import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/features/user/auth/data/models/register_request_model.dart';
import 'package:travel_app/features/user/auth/data/repo/auth_repo.dart';
import 'package:travel_app/features/user/auth/presentation/cubit/auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthRepo _authRepo;
  AuthCubit({required this._authRepo}) : super(const AuthInitial());
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
}
