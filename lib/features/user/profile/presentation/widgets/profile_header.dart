import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/shared/widgets/app_network_image.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/user/auth/data/models/login_response_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserResponseModel user;

  const ProfileHeader({super.key, required this.user});

  String _roleLabel(String? role) {
    switch (role?.toLowerCase()) {
      case 'admin':
        return AppStrings.profileRoleAdmin;
      case 'user':
        return AppStrings.profileRoleUser;
      default:
        return role?.isNotEmpty == true ? role! : '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = user.fullProfileImageUrl;
    final size = 104.r;
    final role = _roleLabel(user.role);

    return Column(
      children: [
        ClipOval(
          child: imageUrl.isNotEmpty
              ? AppNetworkImage(
                  imageUrl: imageUrl,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: size,
                  height: size,
                  color: AppColors.border,
                  child: Icon(
                    Icons.person,
                    size: 48.sp,
                    color: AppColors.textHint,
                  ),
                ),
        ),
        AppSizes.p16.verticalSpace,
        Text(
          user.fullName?.isNotEmpty == true ? user.fullName! : '—',
          textAlign: TextAlign.center,
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (role.isNotEmpty) ...[
          AppSizes.p8.verticalSpace,
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.p12,
              vertical: AppSizes.p4,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.r16),
            ),
            child: Text(
              role,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
