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
import 'package:travel_app/features/user/auth/presentation/cubit/auth_cubit.dart';
import 'package:travel_app/features/user/auth/presentation/cubit/auth_states.dart';
import 'package:travel_app/features/user/auth/presentation/widgets/auth_recovery_hero.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthCubit>().forgotPassword(
      email: _emailController.text.trim(),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          color: AppColors.textPrimary,
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              AppSnackbar.showSuccess(context: context, message: state.message);
              context.push(
                RouteNames.resetPassword,
                extra: state.email,
              );
            } else if (state is AuthFailure) {
              AppSnackbar.showError(context: context, message: state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is ForgotPasswordLoading;
            final canSubmit = _emailController.text.trim().isNotEmpty;

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
                      icon: Icons.mark_email_unread_outlined,
                      title: AppStrings.forgotPasswordTitle,
                      subtitle: AppStrings.forgotPasswordSubtitle,
                      currentStep: 1,
                    ),
                    AppSizes.p32.verticalSpace,
                    Text(
                      AppStrings.forgotPasswordHintLabel,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AppSizes.p8.verticalSpace,
                    Text(
                      AppStrings.forgotPasswordHintBody,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    AppSizes.p24.verticalSpace,
                    AppTextField(
                      controller: _emailController,
                      hintText: AppStrings.emailHint,
                      labelText: AppStrings.emailLabel,
                      type: AppTextFieldType.email,
                      validator: ValidationMessageMapper.validateEmail,
                    ),
                    AppSizes.p32.verticalSpace,
                    AppButton(
                      text: AppStrings.forgotPasswordSendOtp,
                      isLoading: isLoading,
                      isDisabled: !canSubmit || isLoading,
                      onPressed: _onSubmit,
                    ),
                    AppSizes.p16.verticalSpace,
                    TextButton(
                      onPressed: () => context.go(RouteNames.login),
                      child: Text(
                        AppStrings.forgotPasswordBackToLogin,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
