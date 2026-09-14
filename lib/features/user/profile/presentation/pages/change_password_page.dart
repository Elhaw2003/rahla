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
import 'package:travel_app/features/user/auth/data/models/change_password_request_model.dart';
import 'package:travel_app/features/user/auth/presentation/cubit/auth_cubit.dart';
import 'package:travel_app/features/user/auth/presentation/cubit/auth_states.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentPasswordController.addListener(_onChanged);
    _newPasswordController.addListener(_onChanged);
    _confirmPasswordController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _currentPasswordController.removeListener(_onChanged);
    _newPasswordController.removeListener(_onChanged);
    _confirmPasswordController.removeListener(_onChanged);
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  bool get _canSubmit {
    return _currentPasswordController.text.isNotEmpty &&
        _newPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;
  }

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_canSubmit) return;

    context.read<AuthCubit>().changePassword(
      request: ChangePasswordRequestModel(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmNewPassword: _confirmPasswordController.text,
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
          AppStrings.profileChangePassword,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            AppSnackbar.showSuccess(context: context, message: state.message);
            context.pop();
          } else if (state is AuthFailure) {
            AppSnackbar.showError(context: context, message: state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SingleChildScrollView(
            padding: EdgeInsets.all(AppSizes.p24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppStrings.changePasswordSubtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSizes.p32.verticalSpace,
                  AppTextField(
                    controller: _currentPasswordController,
                    hintText: AppStrings.currentPasswordHint,
                    labelText: AppStrings.currentPasswordLabel,
                    type: AppTextFieldType.password,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password required';
                      }
                      return null;
                    },
                  ),
                  AppSizes.p16.verticalSpace,
                  AppTextField(
                    controller: _newPasswordController,
                    hintText: AppStrings.newPasswordHint,
                    labelText: AppStrings.newPasswordLabel,
                    type: AppTextFieldType.password,
                    validator: ValidationMessageMapper.validatePassword,
                  ),
                  AppSizes.p16.verticalSpace,
                  AppTextField(
                    controller: _confirmPasswordController,
                    hintText: AppStrings.confirmNewPasswordHint,
                    labelText: AppStrings.confirmNewPasswordLabel,
                    type: AppTextFieldType.password,
                    validator: (value) =>
                        ValidationMessageMapper.validateConfirmPassword(
                          password: _newPasswordController.text,
                          confirmPassword: value,
                        ),
                  ),
                  AppSizes.p32.verticalSpace,
                  AppButton(
                    text: AppStrings.changePasswordSubmit,
                    isLoading: isLoading,
                    isDisabled: !_canSubmit || isLoading,
                    onPressed: _onSubmit,
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
