import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';

class FavoritesHeader extends StatelessWidget {
  final int? totalItems;

  const FavoritesHeader({super.key, this.totalItems});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.p16,
        AppSizes.p8,
        AppSizes.p16,
        AppSizes.p12,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSizes.p16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.r16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.08),
              AppColors.error.withValues(alpha: 0.10),
            ],
          ),
          border: Border.all(
            color: AppColors.error.withValues(alpha: 0.18),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_rounded,
                color: AppColors.error,
                size: 22.sp,
              ),
            ),
            AppSizes.p12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.favoritesTitle,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (totalItems != null) ...[
                    AppSizes.p4.verticalSpace,
                    Text(
                      AppStrings.favoritesCount(totalItems!),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
