import 'package:equatable/equatable.dart';
import 'package:travel_app/features/user/auth/data/models/login_response_model.dart';
import 'package:travel_app/features/user/auth/data/models/register_response_model.dart';

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

class GoogleAuthLoading extends AuthStates {
  const GoogleAuthLoading();
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

class RegisterSuccess extends AuthStates {
  final RegisterResponseModel registerResponse;
  const RegisterSuccess({required this.registerResponse});
  @override
  List<Object?> get props => [registerResponse];
}

class GoogleLoginSuccess extends AuthStates {
  final LoginResponseModel loginResponse;
  const GoogleLoginSuccess({required this.loginResponse});
  @override
  List<Object?> get props => [loginResponse];
}

class ChangePasswordSuccess extends AuthStates {
  final String message;
  const ChangePasswordSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ForgotPasswordLoading extends AuthStates {
  const ForgotPasswordLoading();
}

class ForgotPasswordSuccess extends AuthStates {
  final String email;
  final String message;

  const ForgotPasswordSuccess({required this.email, required this.message});

  @override
  List<Object?> get props => [email, message];
}

class ResetPasswordLoading extends AuthStates {
  const ResetPasswordLoading();
}

class ResetPasswordSuccess extends AuthStates {
  final String message;

  const ResetPasswordSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class LogoutLoading extends AuthStates {
  const LogoutLoading();
}

class LogoutSuccess extends AuthStates {
  final String message;

  const LogoutSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
