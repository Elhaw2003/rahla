import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/extensions/widget_extension.dart';
import 'package:travel_app/core/helper/app_validation/validation_message_mapper.dart';
import 'package:travel_app/core/router/route_names.dart';
import 'package:travel_app/core/shared/widgets/app_button.dart';
import 'package:travel_app/core/shared/widgets/app_snackbar.dart';
import 'package:travel_app/core/shared/widgets/app_text_field.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/user/auth/presentation/cubit/auth_cubit.dart';
import 'package:travel_app/features/user/auth/presentation/cubit/auth_states.dart';
import 'package:travel_app/features/user/auth/presentation/widgets/social_auth_buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthCubit>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is LoginSuccess || state is GoogleLoginSuccess) {
              final loginResponse = state is LoginSuccess
                  ? state.loginResponse
                  : (state as GoogleLoginSuccess).loginResponse;
              final message = loginResponse.message;
              if (message.isNotEmpty) {
                AppSnackbar.showSuccess(context: context, message: message);
              }

              final role = loginResponse.data?.user?.role;
              if (role == 'admin') {
                context.go(RouteNames.adminDashboard);
              } else {
                context.go(RouteNames.home);
              }
            } else if (state is AuthFailure) {
              AppSnackbar.showError(context: context, message: state.message);
            }
          },
          builder: (context, state) {
            final isLoginLoading = state is AuthLoading;
            final isGoogleLoading = state is GoogleAuthLoading;
            final isBusy = isLoginLoading || isGoogleLoading;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.p24,
                vertical: AppSizes.p32,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    40.h.verticalSpace,
                    Text(
                      AppStrings.welcome,
                      style: AppTextStyles.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    AppSizes.p8.verticalSpace,
                    Text(
                      AppStrings.loginSubtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    40.h.verticalSpace,
                    AppTextField(
                      controller: _emailController,
                      hintText: AppStrings.emailHint,
                      labelText: AppStrings.emailLabel,
                      type: AppTextFieldType.email,
                      validator: ValidationMessageMapper.validateEmail,
                    ),
                    AppSizes.p16.verticalSpace,
                    AppTextField(
                      controller: _passwordController,
                      hintText: AppStrings.passwordHint,
                      labelText: AppStrings.passwordLabel,
                      type: AppTextFieldType.password,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password required';
                        }
                        return null;
                      },
                    ),
                    AppSizes.p8.verticalSpace,
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          AppStrings.forgotPassword,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    AppSizes.p24.verticalSpace,
                    AppButton(
                      text: AppStrings.login,
                      isLoading: isLoginLoading,
                      onPressed: isBusy ? null : _onLogin,
                    ),
                    AppSizes.p32.verticalSpace,
                    SocialAuthButtons(
                      isLoading: isGoogleLoading,
                      onGooglePressed: isBusy
                          ? null
                          : () {
                              context.read<AuthCubit>().signInWithGoogle();
                            },
                    ),
                    40.h.verticalSpace,
                    RichText(
                      text: TextSpan(
                        text: AppStrings.dontHaveAccount,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          TextSpan(
                            text: AppStrings.register,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context.go(RouteNames.register),
                          ),
                        ],
                      ),
                    ).center(),
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
