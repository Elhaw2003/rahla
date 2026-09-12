import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_assets.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/shared/widgets/app_network_image.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/user/user_booking/data/models/user_booking_model.dart';

class BookingDetailsHero extends StatelessWidget {
  final UserBookingModel booking;

  const BookingDetailsHero({super.key, required this.booking});

  String get _routeLabel {
    final origin = booking.origin;
    final destination = booking.destination;
    if (origin.isNotEmpty && destination.isNotEmpty) {
      return '$origin → $destination';
    }
    return destination.isNotEmpty ? destination : origin;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = booking.coverImage;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.r24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.16),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.r24),
        child: SizedBox(
          height: 220.h,
          child: Stack(
            fit: StackFit.expand,
            children: [
              imageUrl.isNotEmpty
                  ? AppNetworkImage(
                      imageUrl: imageUrl,
                      width: double.infinity,
                      height: 220.h,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(AppAssets.homeFeatured, fit: BoxFit.cover),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.15),
                      Colors.black.withValues(alpha: 0.72),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: AppSizes.p16,
                right: AppSizes.p16,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: booking.statusBg,
                    borderRadius: BorderRadius.circular(AppSizes.r24),
                    border: Border.all(
                      color: booking.statusColor.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    booking.statusLabel,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: booking.statusColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              if (booking.isProtected)
                Positioned(
                  top: AppSizes.p16,
                  left: AppSizes.p16,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(AppSizes.r24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_user_rounded,
                          size: 14.sp,
                          color: AppColors.success,
                        ),
                        AppSizes.p4.horizontalSpace,
                        Text(
                          'محمي',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(
                left: AppSizes.p16,
                right: AppSizes.p16,
                bottom: AppSizes.p16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.title.isEmpty ? 'رحلة' : booking.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      ),
                    ),
                    if (_routeLabel.isNotEmpty) ...[
                      AppSizes.p8.verticalSpace,
                      Row(
                        children: [
                          Icon(
                            Icons.route_rounded,
                            size: 16.sp,
                            color: AppColors.secondaryLight,
                          ),
                          AppSizes.p4.horizontalSpace,
                          Expanded(
                            child: Text(
                              _routeLabel,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white.withValues(alpha: 0.92),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
