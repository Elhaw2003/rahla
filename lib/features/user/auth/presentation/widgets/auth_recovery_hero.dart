import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';

class AuthRecoveryHero extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int currentStep;
  final int totalSteps;

  const AuthRecoveryHero({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.currentStep,
    this.totalSteps = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            AppSizes.p20,
            AppSizes.p16,
            AppSizes.p20,
            AppSizes.p24,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.r24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryLight,
                AppColors.secondary.withValues(alpha: 0.85),
              ],
            ),
          ),
          child: Column(
            children: [
              Row(
                children: List.generate(totalSteps, (index) {
                  final isActive = index < currentStep;
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.secondary
                            : Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(AppSizes.r4),
                      ),
                    ),
                  );
                }),
              ),
              AppSizes.p8.verticalSpace,
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  '$currentStep / $totalSteps',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              AppSizes.p16.verticalSpace,
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.28),
                  ),
                ),
                child: Icon(icon, color: Colors.white, size: 34.sp),
              ),
              AppSizes.p16.verticalSpace,
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              AppSizes.p8.verticalSpace,
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.88),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
