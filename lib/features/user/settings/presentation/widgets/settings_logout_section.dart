import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/di/dependency_injection.dart';
import 'package:travel_app/core/router/route_names.dart';
import 'package:travel_app/core/shared/widgets/app_snackbar.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/user/auth/presentation/cubit/auth_cubit.dart';
import 'package:travel_app/features/user/auth/presentation/cubit/auth_states.dart';
import 'package:travel_app/features/user/profile/presentation/cubit/profile_cubit.dart';
import 'package:travel_app/features/user/profile/presentation/widgets/profile_logout_button.dart';

class SettingsLogoutSection extends StatelessWidget {
  const SettingsLogoutSection({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            AppStrings.profileLogout,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            AppStrings.logoutConfirmMessage,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                AppStrings.cancel,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(
                AppStrings.profileLogout,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      context.read<AuthCubit>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            getIt<ProfileCubit>().clear();
            if (state.message.isNotEmpty) {
              AppSnackbar.showSuccess(context: context, message: state.message);
            }
            context.go(RouteNames.login);
          }
        },
        builder: (context, state) {
          final isLoading = state is LogoutLoading;
          return ProfileLogoutButton(
            isLoading: isLoading,
            onPressed: isLoading ? null : () => _confirmLogout(context),
          );
        },
      ),
    );
  }
}
