import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/shared/widgets/app_network_image.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/user/auth/data/models/login_response_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserResponseModel user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final imageUrl = user.fullProfileImageUrl;
    final size = 100.r;

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
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
            Container(
              padding: EdgeInsets.all(AppSizes.p4),
              decoration: BoxDecoration(
                color: const Color(0xFF91590F),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(Icons.camera_alt, color: Colors.white, size: 16.sp),
            ),
          ],
        ),
        AppSizes.p16.verticalSpace,
        Text(
          user.fullName?.isNotEmpty == true ? user.fullName! : '—',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSizes.p4.verticalSpace,
        Text(
          user.email?.isNotEmpty == true ? user.email! : '—',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        if (user.phone != null && user.phone!.isNotEmpty) ...[
          AppSizes.p4.verticalSpace,
          Text(
            user.phone!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
