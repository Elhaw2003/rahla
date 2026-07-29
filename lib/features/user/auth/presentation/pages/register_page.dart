import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/extensions/widget_extension.dart';
import 'package:travel_app/core/router/route_names.dart';
import 'package:travel_app/core/shared/widgets/app_button.dart';
import 'package:travel_app/core/shared/widgets/app_text_field.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/user/auth/presentation/widgets/profile_avatar_picker.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.p24,
            vertical: AppSizes.p16,
          ),
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
              const ProfileAvatarPicker(),
              32.h.verticalSpace,
              AppTextField(
                hintText: AppStrings.nameHint,
                labelText: AppStrings.nameLabel,
                type: AppTextFieldType.text,
              ),
              AppSizes.p16.verticalSpace,
              AppTextField(
                hintText: AppStrings.emailHint,
                labelText: AppStrings.emailLabel,
                type: AppTextFieldType.email,
              ),
              AppSizes.p16.verticalSpace,
              AppTextField(
                hintText: AppStrings.phoneHint,
                labelText: AppStrings.phoneLabel,
                type: AppTextFieldType.phone,
              ),
              AppSizes.p16.verticalSpace,
              AppTextField(
                hintText: AppStrings.passwordHint,
                labelText: AppStrings.passwordLabel,
                type: AppTextFieldType.password,
              ),
              AppSizes.p16.verticalSpace,
              AppTextField(
                hintText: AppStrings.confirmPasswordHint,
                labelText: AppStrings.confirmPasswordLabel,
                type: AppTextFieldType.password,
              ),
              AppSizes.p32.verticalSpace,
              AppButton(
                text: AppStrings.register,
                onPressed: () {
                  context.go(RouteNames.home);
                },
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
      ),
    );
  }
}
