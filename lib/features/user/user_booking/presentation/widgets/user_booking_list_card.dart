import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_assets.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/shared/widgets/app_network_image.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/user/user_booking/data/models/user_booking_model.dart';

class UserBookingListCard extends StatelessWidget {
  final UserBookingModel booking;
  final VoidCallback? onTap;

  const UserBookingListCard({
    super.key,
    required this.booking,
    this.onTap,
  });

  String _formatPrice(num price) {
    return NumberFormat('#,###').format(price);
  }

  String get _dateLabel {
    final start = booking.tripSnapshot?.startDate ?? booking.trip?.startDate;
    final end = booking.tripSnapshot?.endDate ?? booking.trip?.endDate;
    final startDate = DateTime.tryParse(start ?? '');
    final endDate = DateTime.tryParse(end ?? '');
    if (startDate == null && endDate == null) {
      return booking.formattedCreatedAt;
    }
    if (startDate != null && endDate != null) {
      return '${startDate.day}/${startDate.month} - ${endDate.day}/${endDate.month}/${endDate.year}';
    }
    final only = startDate ?? endDate!;
    return '${only.day}/${only.month}/${only.year}';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = booking.coverImage;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.r16),
      child: Container(
        padding: EdgeInsets.all(AppSizes.p16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.r16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                  child: SizedBox(
                    width: 72.w,
                    height: 72.w,
                    child: imageUrl.isNotEmpty
                        ? AppNetworkImage(
                            imageUrl: imageUrl,
                            width: 72.w,
                            height: 72.w,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            AppAssets.homeFeatured,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                AppSizes.p12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              booking.title.isEmpty
                                  ? 'رحلة بدون عنوان'
                                  : booking.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                              ),
                            ),
                          ),
                          AppSizes.p8.horizontalSpace,
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: booking.statusBg,
                              borderRadius: BorderRadius.circular(AppSizes.r12),
                            ),
                            child: Text(
                              booking.statusLabel,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: booking.statusColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppSizes.p8.verticalSpace,
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            size: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                          AppSizes.p4.horizontalSpace,
                          Expanded(
                            child: Text(
                              _dateLabel,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppSizes.p4.verticalSpace,
                      Text(
                        '${booking.numberOfSeats} مقاعد',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSizes.p12.verticalSpace,
            const Divider(height: 1, color: AppColors.divider),
            AppSizes.p12.verticalSpace,
            Row(
              children: [
                Text(
                  '${_formatPrice(booking.totalPrice)} ${AppStrings.currencyEGP}',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Text(
                  AppStrings.bookingsViewDetails,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppSizes.p4.horizontalSpace,
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12.sp,
                  color: AppColors.secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
