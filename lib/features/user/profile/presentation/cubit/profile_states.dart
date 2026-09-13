import 'package:equatable/equatable.dart';
import 'package:travel_app/features/user/auth/data/models/login_response_model.dart';

abstract class ProfileStates extends Equatable {
  const ProfileStates();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileStates {
  const ProfileInitial();
}

class ProfileLoading extends ProfileStates {
  const ProfileLoading();
}

class ProfileSuccess extends ProfileStates {
  final UserResponseModel user;

  const ProfileSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class ProfileFailure extends ProfileStates {
  final String message;

  const ProfileFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
