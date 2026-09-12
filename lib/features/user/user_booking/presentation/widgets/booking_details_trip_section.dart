import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/user/user_booking/data/models/user_booking_model.dart';

class BookingDetailsTripSection extends StatelessWidget {
  final UserBookingModel booking;

  const BookingDetailsTripSection({super.key, required this.booking});

  String _formatDate(String? raw) {
    final date = DateTime.tryParse(raw ?? '');
    if (date == null) return '—';
    return '${date.day}/${date.month}/${date.year}';
  }

  String get _dateRange {
    final start =
        booking.tripSnapshot?.startDate ?? booking.trip?.startDate;
    final end = booking.tripSnapshot?.endDate ?? booking.trip?.endDate;
    final startLabel = _formatDate(start);
    final endLabel = _formatDate(end);
    if (startLabel == '—' && endLabel == '—') return '—';
    if (startLabel != '—' && endLabel != '—') {
      return '$startLabel - $endLabel';
    }
    return startLabel != '—' ? startLabel : endLabel;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.flight_takeoff_rounded,
                color: AppColors.primary,
                size: 20.sp,
              ),
              AppSizes.p8.horizontalSpace,
              Text(
                AppStrings.bookingDetailsTripData,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          AppSizes.p16.verticalSpace,
          _InfoTile(
            icon: Icons.place_outlined,
            label: AppStrings.bookingDetailsDestination,
            value: booking.destination.isEmpty ? '—' : booking.destination,
          ),
          AppSizes.p12.verticalSpace,
          _InfoTile(
            icon: Icons.calendar_month_outlined,
            label: AppStrings.bookingDetailsTripDates,
            value: _dateRange,
          ),
          if (booking.durationLabel.isNotEmpty) ...[
            AppSizes.p12.verticalSpace,
            _InfoTile(
              icon: Icons.schedule_rounded,
              label: AppStrings.bookingDetailsDuration,
              value: booking.durationLabel,
            ),
          ],
          if (booking.origin.isNotEmpty) ...[
            AppSizes.p12.verticalSpace,
            _InfoTile(
              icon: Icons.trip_origin_rounded,
              label: 'نقطة الانطلاق',
              value: booking.origin,
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppSizes.r8),
            ),
            child: Icon(icon, size: 18.sp, color: AppColors.primary),
          ),
          AppSizes.p12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
