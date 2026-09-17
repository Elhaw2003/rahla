import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/helper/app_validation/validation_message_mapper.dart';
import 'package:travel_app/core/router/route_names.dart';
import 'package:travel_app/core/shared/widgets/app_button.dart';
import 'package:travel_app/core/shared/widgets/app_snackbar.dart';
import 'package:travel_app/core/shared/widgets/app_text_field.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/user/auth/data/models/reset_password_request_model.dart';
import 'package:travel_app/features/user/auth/presentation/cubit/auth_cubit.dart';
import 'package:travel_app/features/user/auth/presentation/cubit/auth_states.dart';
import 'package:travel_app/features/user/auth/presentation/widgets/auth_recovery_hero.dart';
import 'package:travel_app/features/user/auth/presentation/widgets/otp_input_row.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpKey = GlobalKey<OtpInputRowState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _otp = '';

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_onChanged);
    _confirmPasswordController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _newPasswordController.removeListener(_onChanged);
    _confirmPasswordController.removeListener(_onChanged);
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  bool get _canSubmit =>
      _otp.length == 6 &&
      _newPasswordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty;

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_otp.length != 6) {
      AppSnackbar.showError(
        context: context,
        message: AppStrings.resetPasswordOtpRequired,
      );
      return;
    }

    context.read<AuthCubit>().resetPassword(
      request: ResetPasswordRequestModel(
        email: widget.email,
        otp: _otp,
        newPassword: _newPasswordController.text,
        confirmNewPassword: _confirmPasswordController.text,
        isProtected: true,
      ),
    );
  }

  Future<void> _resendOtp() async {
    await context.read<AuthCubit>().forgotPassword(email: widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          color: AppColors.textPrimary,
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is ResetPasswordSuccess) {
              AppSnackbar.showSuccess(context: context, message: state.message);
              context.go(RouteNames.login);
            } else if (state is ForgotPasswordSuccess) {
              AppSnackbar.showSuccess(context: context, message: state.message);
              _otpKey.currentState?.clear();
              setState(() => _otp = '');
            } else if (state is AuthFailure) {
              AppSnackbar.showError(context: context, message: state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is ResetPasswordLoading;
            final isResending = state is ForgotPasswordLoading;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppSizes.p24,
                AppSizes.p8,
                AppSizes.p24,
                AppSizes.p32,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthRecoveryHero(
                      icon: Icons.lock_reset_rounded,
                      title: AppStrings.resetPasswordTitle,
                      subtitle: AppStrings.resetPasswordSubtitle(widget.email),
                      currentStep: 2,
                    ),
                    AppSizes.p24.verticalSpace,
                    Text(
                      AppStrings.resetPasswordOtpLabel,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AppSizes.p12.verticalSpace,
                    OtpInputRow(
                      key: _otpKey,
                      onChanged: (value) => setState(() => _otp = value),
                      onCompleted: (value) => setState(() => _otp = value),
                    ),
                    AppSizes.p12.verticalSpace,
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton(
                        onPressed: isResending || isLoading ? null : _resendOtp,
                        child: isResending
                            ? SizedBox(
                                width: 18.w,
                                height: 18.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                AppStrings.resetPasswordResendOtp,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
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
                      text: AppStrings.resetPasswordSubmit,
                      isLoading: isLoading,
                      isDisabled: !_canSubmit || isLoading || isResending,
                      onPressed: _onSubmit,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
