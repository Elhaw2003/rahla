import 'package:equatable/equatable.dart';
import 'package:travel_app/features/user/auth/data/models/login_response_model.dart';

class AuthStates extends Equatable {
  const AuthStates();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthStates {
  const AuthInitial();
}

class AuthLoading extends AuthStates {
  const AuthLoading();
}

class LoginSuccess extends AuthStates {
  final LoginResponseModel loginResponse;
  const LoginSuccess({required this.loginResponse});

  @override
  List<Object?> get props => [loginResponse];
}

class AuthFailure extends AuthStates {
  final String message;
  const AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
