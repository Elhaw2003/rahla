import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/shared/widgets/app_button.dart';

class ProfileLogoutButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const ProfileLogoutButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AppButton.outlined(
        text: AppStrings.profileLogout,
        foregroundColor: Colors.red,
        borderColor: Colors.red.withValues(alpha: 0.3),
        isLoading: isLoading,
        isDisabled: isLoading,
        icon: Icon(Icons.logout, color: Colors.red, size: 20.sp),
        onPressed: onPressed,
      ),
    );
  }
}
