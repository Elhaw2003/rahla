import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/helper/app_validation/validation_message_mapper.dart';
import 'package:travel_app/core/shared/widgets/app_button.dart';
import 'package:travel_app/core/shared/widgets/app_snackbar.dart';
import 'package:travel_app/core/shared/widgets/app_text_field.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/user/auth/data/models/login_response_model.dart';
import 'package:travel_app/features/user/auth/data/models/update_profile_request_model.dart';
import 'package:travel_app/features/user/auth/presentation/widgets/profile_avatar_picker.dart';
import 'package:travel_app/features/user/profile/presentation/cubit/profile_cubit.dart';
import 'package:travel_app/features/user/profile/presentation/cubit/profile_states.dart';
import 'package:travel_app/features/user/profile/presentation/widgets/profile_error_view.dart';
import 'package:travel_app/features/user/profile/presentation/widgets/profile_loading_view.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  String _initialName = '';
  String _initialPhone = '';
  String? _networkImageUrl;
  String? _newImagePath;
  bool _hydrated = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFormChanged);
    _phoneController.addListener(_onFormChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<ProfileCubit>();
      final state = cubit.state;
      if (state is ProfileSuccess ||
          state is ProfileUpdating ||
          state is ProfileUpdateFailure) {
        final user = state is ProfileSuccess
            ? state.user
            : state is ProfileUpdating
            ? state.user
            : (state as ProfileUpdateFailure).user;
        _hydrate(user);
      } else if (cubit.currentUser != null) {
        _hydrate(cubit.currentUser!);
      } else {
        cubit.getUserProfile();
      }
    });
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFormChanged);
    _phoneController.removeListener(_onFormChanged);
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    if (mounted) setState(() {});
  }

  void _hydrate(UserResponseModel user) {
    if (_hydrated) return;
    _initialName = user.fullName?.trim() ?? '';
    _initialPhone = user.phone?.trim() ?? '';
    _networkImageUrl = user.fullProfileImageUrl;
    _nameController.text = _initialName;
    _phoneController.text = _initialPhone;
    _hydrated = true;
    setState(() {});
  }

  bool get _hasChanges {
    final nameChanged = _nameController.text.trim() != _initialName;
    final phoneChanged = _phoneController.text.trim() != _initialPhone;
    final imageChanged = _newImagePath != null && _newImagePath!.isNotEmpty;
    return nameChanged || phoneChanged || imageChanged;
  }

  void _onSave() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_hasChanges) return;

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    context.read<ProfileCubit>().updateProfile(
      request: UpdateProfileRequestModel(
        fullName: name != _initialName ? name : null,
        phone: phone != _initialPhone ? phone : null,
        profileImage: _newImagePath,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          color: AppColors.textPrimary,
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppStrings.profileEditAccount,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocConsumer<ProfileCubit, ProfileStates>(
        listener: (context, state) {
          if (state is ProfileSuccess && !_hydrated) {
            _hydrate(state.user);
          } else if (state is ProfileUpdateSuccess) {
            AppSnackbar.showSuccess(context: context, message: state.message);
            _hydrated = false;
            _newImagePath = null;
            _hydrate(state.user);
            context.pop();
          } else if (state is ProfileUpdateFailure) {
            AppSnackbar.showError(context: context, message: state.message);
          } else if (state is ProfileFailure) {
            AppSnackbar.showError(context: context, message: state.message);
          }
        },
        builder: (context, state) {
          if ((state is ProfileLoading || state is ProfileInitial) &&
              !_hydrated) {
            return const ProfileLoadingView();
          }

          if (state is ProfileFailure && !_hydrated) {
            return ProfileErrorView(
              message: state.message,
              onRetry: () => context.read<ProfileCubit>().getUserProfile(),
            );
          }

          final isUpdating = state is ProfileUpdating;

          return SingleChildScrollView(
            padding: EdgeInsets.all(AppSizes.p24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProfileAvatarPicker(
                    imagePath: _newImagePath,
                    networkImageUrl: _networkImageUrl,
                    onImageChanged: (path) {
                      setState(() => _newImagePath = path);
                    },
                  ),
                  AppSizes.p32.verticalSpace,
                  AppTextField(
                    controller: _nameController,
                    hintText: AppStrings.nameHint,
                    labelText: AppStrings.nameLabel,
                    type: AppTextFieldType.text,
                    validator: ValidationMessageMapper.validateName,
                  ),
                  AppSizes.p16.verticalSpace,
                  AppTextField(
                    controller: _phoneController,
                    hintText: AppStrings.phoneHint,
                    labelText: AppStrings.phoneLabel,
                    type: AppTextFieldType.phone,
                    validator: ValidationMessageMapper.validatePhone,
                  ),
                  AppSizes.p32.verticalSpace,
                  AppButton(
                    text: AppStrings.profileSaveChanges,
                    isLoading: isUpdating,
                    isDisabled: !_hasChanges || isUpdating,
                    onPressed: _onSave,
                  ),
                  AppSizes.p16.verticalSpace,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
