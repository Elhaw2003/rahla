import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/features/user/auth/data/repo/auth_repo.dart';
import 'package:travel_app/features/user/profile/presentation/cubit/profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit({required AuthRepo authRepo})
    : _authRepo = authRepo,
      super(const ProfileInitial());

  final AuthRepo _authRepo;

  Future<void> getUserProfile() async {
    emit(const ProfileLoading());
    final result = await _authRepo.getUserProfile();
    result.fold(
      (failure) => emit(ProfileFailure(message: failure.message)),
      (user) => emit(ProfileSuccess(user: user)),
    );
  }
}
