import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';

class CreateBookingPriceSummary extends StatelessWidget {
  final int seats;
  final num pricePerSeat;
  final num totalPrice;

  const CreateBookingPriceSummary({
    super.key,
    required this.seats,
    required this.pricePerSeat,
    required this.totalPrice,
  });

  String _formatPrice(num price) {
    return NumberFormat('#,###').format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.r16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.06),
            AppColors.secondary.withValues(alpha: 0.12),
          ],
        ),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.28),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long_rounded,
                color: AppColors.secondary,
                size: 20.sp,
              ),
              AppSizes.p8.horizontalSpace,
              Text(
                AppStrings.bookingConfirmationPriceSummary,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          AppSizes.p16.verticalSpace,
          _PriceRow(
            label:
                '${AppStrings.bookingConfirmationTripCost} ($seats × ${_formatPrice(pricePerSeat)})',
            value: '${_formatPrice(seats * pricePerSeat)} ${AppStrings.currencyEGP}',
          ),
          AppSizes.p12.verticalSpace,
          const Divider(height: 1, color: AppColors.divider),
          AppSizes.p12.verticalSpace,
          Row(
            children: [
              Text(
                AppStrings.bookingConfirmationFinalPrice,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                '${_formatPrice(totalPrice)} ${AppStrings.currencyEGP}',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;

  const _PriceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
