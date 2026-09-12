import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/extensions/widget_extension.dart';
import 'package:travel_app/core/shared/widgets/app_button.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';

class CreateBookingBottomBar extends StatelessWidget {
  final num totalPrice;
  final bool isLoading;
  final VoidCallback? onConfirm;

  const CreateBookingBottomBar({
    super.key,
    required this.totalPrice,
    required this.isLoading,
    required this.onConfirm,
  });

  String _formatPrice(num price) {
    return NumberFormat('#,###').format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.p24,
        AppSizes.p16,
        AppSizes.p24,
        AppSizes.p16,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.bookingConfirmationFinalPrice,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${_formatPrice(totalPrice)} ${AppStrings.currencyEGP}',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            AppSizes.p16.horizontalSpace,
            AppButton(
              text: AppStrings.bookingConfirmationConfirmBooking,
              isLoading: isLoading,
              onPressed: onConfirm,
            ).expanded(),
          ],
        ),
      ),
    );
  }
}
