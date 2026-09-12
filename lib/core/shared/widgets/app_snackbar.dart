import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';

class AppSnackbar {
  AppSnackbar._();

  static void showSuccess({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _show(
      context: context,
      message: message,
      backgroundColor: const Color(0xFF1B7F4E),
      icon: Icons.check_circle_rounded,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
  }) {
    _show(
      context: context,
      message: message,
      backgroundColor: AppColors.error,
      icon: Icons.error_rounded,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
  }) {
    _show(
      context: context,
      message: message,
      backgroundColor: AppColors.primary,
      icon: Icons.info_rounded,
    );
  }

  static void _show({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        duration: Duration(seconds: actionLabel != null ? 4 : 3),
        margin: EdgeInsets.fromLTRB(
          AppSizes.p16,
          0,
          AppSizes.p16,
          AppSizes.p16,
        ),
        padding: EdgeInsets.zero,
        content: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.p16,
            vertical: AppSizes.p12,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppSizes.r16),
            boxShadow: [
              BoxShadow(
                color: backgroundColor.withValues(alpha: 0.28),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 22.sp),
              AppSizes.p12.horizontalSpace,
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ),
              if (actionLabel != null && onAction != null) ...[
                AppSizes.p8.horizontalSpace,
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    messenger.hideCurrentSnackBar();
                    onAction();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSizes.p4),
                    child: Text(
                      actionLabel,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                        decorationThickness: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
