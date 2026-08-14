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
import 'package:travel_app/features/user/auth/data/models/register_request_model.dart';
import 'package:travel_app/features/user/auth/presentation/cubit/auth_cubit.dart';
import 'package:travel_app/features/user/auth/presentation/cubit/auth_states.dart';
import 'package:travel_app/features/user/auth/presentation/widgets/profile_avatar_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _profileImagePath;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthCubit>().register(
      request: RegisterRequestModel(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        profileImage: _profileImagePath,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              final message = state.registerResponse.message;
              if (message != null && message.isNotEmpty) {
                AppSnackbar.showSuccess(context: context, message: message);
              }

              final role = state.registerResponse.user?.role;
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
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.p24,
                vertical: AppSizes.p16,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppStrings.createAccountTitle,
                      style: AppTextStyles.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    AppSizes.p8.verticalSpace,
                    Text(
                      AppStrings.createAccountSubtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    32.h.verticalSpace,
                    ProfileAvatarPicker(
                      imagePath: _profileImagePath,
                      onImageChanged: (path) {
                        setState(() => _profileImagePath = path);
                      },
                    ),
                    32.h.verticalSpace,
                    AppTextField(
                      controller: _nameController,
                      hintText: AppStrings.nameHint,
                      labelText: AppStrings.nameLabel,
                      type: AppTextFieldType.text,
                      validator: ValidationMessageMapper.validateName,
                    ),
                    AppSizes.p16.verticalSpace,
                    AppTextField(
                      controller: _emailController,
                      hintText: AppStrings.emailHint,
                      labelText: AppStrings.emailLabel,
                      type: AppTextFieldType.email,
                      validator: ValidationMessageMapper.validateEmail,
                    ),
                    AppSizes.p16.verticalSpace,
                    AppTextField(
                      controller: _phoneController,
                      hintText: AppStrings.phoneHint,
                      labelText: AppStrings.phoneLabel,
                      type: AppTextFieldType.phone,
                      validator: ValidationMessageMapper.validatePhone,
                    ),
                    AppSizes.p16.verticalSpace,
                    AppTextField(
                      controller: _passwordController,
                      hintText: AppStrings.passwordHint,
                      labelText: AppStrings.passwordLabel,
                      type: AppTextFieldType.password,
                      validator: ValidationMessageMapper.validatePassword,
                    ),
                    AppSizes.p16.verticalSpace,
                    AppTextField(
                      controller: _confirmPasswordController,
                      hintText: AppStrings.confirmPasswordHint,
                      labelText: AppStrings.confirmPasswordLabel,
                      type: AppTextFieldType.password,
                      validator: (value) =>
                          ValidationMessageMapper.validateConfirmPassword(
                            password: _passwordController.text,
                            confirmPassword: value,
                          ),
                    ),
                    AppSizes.p32.verticalSpace,
                    AppButton(
                      text: AppStrings.register,
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _onRegister,
                    ),
                    AppSizes.p32.verticalSpace,
                    RichText(
                      text: TextSpan(
                        text: AppStrings.alreadyHaveAccount,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          TextSpan(
                            text: AppStrings.login,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context.go(RouteNames.login),
                          ),
                        ],
                      ),
                    ).center(),
                    AppSizes.p32.verticalSpace,
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
