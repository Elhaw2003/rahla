import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/features/user/auth/data/models/login_response_model.dart';
import 'package:travel_app/features/user/auth/data/models/update_profile_request_model.dart';
import 'package:travel_app/features/user/auth/data/repo/auth_repo.dart';
import 'package:travel_app/features/user/profile/presentation/cubit/profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit({required AuthRepo authRepo})
    : _authRepo = authRepo,
      super(const ProfileInitial());

  final AuthRepo _authRepo;
  UserResponseModel? _currentUser;

  UserResponseModel? get currentUser => _currentUser;

  Future<void> getUserProfile() async {
    emit(const ProfileLoading());
    final result = await _authRepo.getUserProfile();
    result.fold((failure) => emit(ProfileFailure(message: failure.message)), (
      user,
    ) {
      _currentUser = user;
      emit(ProfileSuccess(user: user));
    });
  }

  Future<void> updateProfile({required UpdateProfileRequestModel request}) async {
    final user = _currentUser;
    if (user == null) {
      emit(const ProfileFailure(message: 'User profile is not loaded'));
      return;
    }

    emit(ProfileUpdating(user: user));
    final result = await _authRepo.updateProfile(request: request);
    result.fold(
      (failure) => emit(
        ProfileUpdateFailure(user: user, message: failure.message),
      ),
      (updatedUser) {
        _currentUser = updatedUser;
        emit(
          ProfileUpdateSuccess(
            user: updatedUser,
            message: 'تم تحديث الملف الشخصي بنجاح',
          ),
        );
        emit(ProfileSuccess(user: updatedUser));
      },
    );
  }
}