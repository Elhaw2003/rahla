import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';

class ExploreScrollIntro extends StatelessWidget {
  final String? selectedCategoryName;
  final int? tripsCount;

  const ExploreScrollIntro({
    super.key,
    this.selectedCategoryName,
    this.tripsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.p16,
        AppSizes.p16,
        AppSizes.p16,
        AppSizes.p8,
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
              AppColors.secondary.withValues(alpha: 0.16),
            ],
          ),
          border: Border.all(
            color: AppColors.secondary.withValues(alpha: 0.28),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedCategoryName?.isNotEmpty == true
                  ? selectedCategoryName!
                  : AppStrings.exploreSubtitle,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (tripsCount != null) ...[
              AppSizes.p8.verticalSpace,
              Text(
                AppStrings.exploreTripsCount(tripsCount!),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
