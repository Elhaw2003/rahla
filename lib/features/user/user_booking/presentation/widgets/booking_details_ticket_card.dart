import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/user/user_booking/data/models/user_booking_model.dart';

class BookingDetailsTicketCard extends StatelessWidget {
  final UserBookingModel booking;

  const BookingDetailsTicketCard({super.key, required this.booking});

  String _formatPrice(num price) {
    return NumberFormat('#,###').format(price);
  }

  String get _shortId {
    final id = booking.id;
    if (id.length <= 8) return id.toUpperCase();
    return id.substring(id.length - 8).toUpperCase();
  }

  double get _pricePerSeat {
    final snapshot = booking.tripSnapshot?.pricePerSeat ?? 0;
    if (snapshot > 0) return snapshot;
    return booking.trip?.price ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSizes.p20,
              AppSizes.p20,
              AppSizes.p20,
              AppSizes.p16,
            ),
            child: Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSizes.r12),
                  ),
                  child: Icon(
                    Icons.confirmation_number_rounded,
                    color: AppColors.secondary,
                    size: 22.sp,
                  ),
                ),
                AppSizes.p12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.bookingDetailsBookingData,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      AppSizes.p4.verticalSpace,
                      Text(
                        '#$_shortId',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _DashedDivider(),
          Padding(
            padding: EdgeInsets.all(AppSizes.p20),
            child: Column(
              children: [
                _TicketRow(
                  label: AppStrings.bookingDetailsBookingDate,
                  value: booking.formattedCreatedAt.isEmpty
                      ? '—'
                      : booking.formattedCreatedAt,
                ),
                AppSizes.p12.verticalSpace,
                _TicketRow(
                  label: AppStrings.bookingDetailsIndividuals,
                  value: '${booking.numberOfSeats} مقاعد',
                ),
                AppSizes.p12.verticalSpace,
                _TicketRow(
                  label: 'سعر المقعد',
                  value: _pricePerSeat > 0
                      ? '${_formatPrice(_pricePerSeat)} ${AppStrings.currencyEGP}'
                      : '—',
                ),
                AppSizes.p16.verticalSpace,
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSizes.p12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.08),
                        AppColors.secondary.withValues(alpha: 0.12),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.r12),
                  ),
                  child: Row(
                    children: [
                      Text(
                        AppStrings.bookingDetailsTotalPrice,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${_formatPrice(booking.totalPrice)} ${AppStrings.currencyEGP}',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
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

class _TicketRow extends StatelessWidget {
  final String label;
  final String value;

  const _TicketRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        AppSizes.p12.horizontalSpace,
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 6.0;
        const dashSpace = 4.0;
        final count = (constraints.maxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => SizedBox(
              width: dashWidth,
              height: 1.5,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
