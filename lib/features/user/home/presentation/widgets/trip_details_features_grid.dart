import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/extensions/widget_extension.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';

class TripDetailsFeaturesGrid extends StatelessWidget {
  final AdminTripModel trip;

  const TripDetailsFeaturesGrid({super.key, required this.trip});

  int get _daysCount {
    if (trip.days.isNotEmpty) return trip.days.length;
    final start = DateTime.tryParse(trip.startDate ?? '');
    final end = DateTime.tryParse(trip.endDate ?? '');
    if (start == null || end == null) return 0;
    return end.difference(start).inDays.abs().clamp(1, 365);
  }

  @override
  Widget build(BuildContext context) {
    final destination = trip.destination?.isNotEmpty == true
        ? trip.destination!
        : (trip.origin ?? '—');

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeatureCard(
            icon: Icons.event_seat_outlined,
            line1: '${trip.availableSeats}',
            line2: AppStrings.tripDetailsAvailableSeats,
          ).expanded(),
          AppSizes.p8.horizontalSpace,
          FeatureCard(
            icon: Icons.calendar_today,
            line1: '$_daysCount',
            line2: AppStrings.tripDetailsDays,
          ).expanded(),
          AppSizes.p8.horizontalSpace,
          FeatureCard(
            icon: Icons.location_on,
            line1: '',
            line2: destination,
          ).expanded(),
          AppSizes.p8.horizontalSpace,
          FeatureCard(
            icon: Icons.groups_outlined,
            line1: '${trip.capacity}',
            line2: AppStrings.tripDetailsCapacity,
          ).expanded(),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String line1;
  final String line2;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.line1,
    required this.line2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primaryDark, size: 20.sp),
          AppSizes.p8.verticalSpace,
          if (line1.isNotEmpty)
            Text(
              line1,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          Text(
            line2,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
