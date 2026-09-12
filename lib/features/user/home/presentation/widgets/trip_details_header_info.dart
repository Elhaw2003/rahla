import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';

class TripDetailsHeaderInfo extends StatelessWidget {
  final AdminTripModel trip;

  const TripDetailsHeaderInfo({super.key, required this.trip});

  String _formatPrice(num price) {
    return NumberFormat('#,###').format(price);
  }

  String _durationLabel() {
    final start = DateTime.tryParse(trip.startDate ?? '');
    final end = DateTime.tryParse(trip.endDate ?? '');
    if (start == null || end == null) {
      if (trip.days.isNotEmpty) {
        return '${trip.days.length} ${AppStrings.tripDetailsDays}';
      }
      return '';
    }
    final days = end.difference(start).inDays.abs();
    if (days <= 1) return '1 يوم / 1 ليلة';
    return '$days أيام / ${days - 1} ليلة';
  }

  String get _title {
    if (trip.title?.isNotEmpty == true) return trip.title!;
    if (trip.destination?.isNotEmpty == true) return trip.destination!;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final duration = _durationLabel();
    final hasRating = trip.averageRating > 0 || trip.reviewsCount > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _title,
                    style: AppTextStyles.displaySmall.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  if (duration.isNotEmpty) ...[
                    AppSizes.p8.verticalSpace,
                    Text(
                      duration,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  if (trip.origin?.isNotEmpty == true &&
                      trip.destination?.isNotEmpty == true) ...[
                    AppSizes.p8.verticalSpace,
                    Row(
                      children: [
                        Icon(
                          Icons.route_rounded,
                          size: 16.sp,
                          color: AppColors.secondary,
                        ),
                        AppSizes.p4.horizontalSpace,
                        Expanded(
                          child: Text(
                            '${trip.origin} → ${trip.destination}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (hasRating)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.r8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (trip.reviewsCount > 0)
                      Text(
                        '(${trip.reviewsCount})',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    if (trip.reviewsCount > 0) AppSizes.p4.horizontalSpace,
                    Text(
                      trip.averageRating.toStringAsFixed(1),
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSizes.p4.horizontalSpace,
                    Icon(Icons.star, color: AppColors.secondary, size: 16.sp),
                  ],
                ),
              ),
          ],
        ),
        AppSizes.p16.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              AppStrings.tripDetailsPerPerson,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSizes.p8.horizontalSpace,
            Text(
              _formatPrice(trip.price),
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSizes.p4.horizontalSpace,
            Text(
              AppStrings.currencyEGP,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
