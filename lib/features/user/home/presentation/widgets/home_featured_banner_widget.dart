import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/core/constants/app_assets.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/extensions/widget_extension.dart';
import 'package:travel_app/core/router/route_names.dart';
import 'package:travel_app/core/shared/widgets/app_network_image.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';

class HomeFeaturedBannerWidget extends StatelessWidget {
  final AdminTripModel? trip;

  const HomeFeaturedBannerWidget({super.key, this.trip});

  String _imageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return 'https://rahala.duckdns.org$path';
  }

  String _formatPrice(num price) {
    return '${NumberFormat('#,###').format(price)} ${AppStrings.currencyEGP}';
  }

  String _formatDuration(String? start, String? end) {
    final startDate = DateTime.tryParse(start ?? '');
    final endDate = DateTime.tryParse(end ?? '');
    if (startDate == null || endDate == null) return '';
    final days = endDate.difference(startDate).inDays.abs();
    if (days <= 1) return '1 يوم / 1 ليلة';
    return '$days أيام / ${days - 1} ليلة';
  }

  @override
  Widget build(BuildContext context) {
    final title = trip?.destination?.isNotEmpty == true
        ? trip!.destination!
        : (trip?.title ?? AppStrings.homeFeaturedTrip);
    final price = trip == null ? '—' : _formatPrice(trip!.price);
    final duration = _formatDuration(trip?.startDate, trip?.endDate);
    final rating = trip?.averageRating == 0
        ? null
        : trip?.averageRating.toStringAsFixed(1);
    final imageUrl = _imageUrl(trip?.coverImage);

    return GestureDetector(
      onTap: trip == null
          ? null
          : () => context.push(RouteNames.tripDetails, extra: trip),
      child: Container(
        height: 140.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.r16),
          color: AppColors.primaryDark,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl.isNotEmpty)
              AppNetworkImage(
                imageUrl: imageUrl,
                width: double.infinity,
                height: 140.h,
                fit: BoxFit.cover,
              )
            else
              Image.asset(AppAssets.homeFeatured, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSizes.p16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.titleLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (duration.isNotEmpty || rating != null) ...[
                            AppSizes.p4.verticalSpace,
                            Row(
                              children: [
                                if (duration.isNotEmpty) ...[
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.white70,
                                    size: 14.sp,
                                  ),
                                  AppSizes.p4.horizontalSpace,
                                  Text(
                                    duration,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                                if (rating != null) ...[
                                  AppSizes.p12.horizontalSpace,
                                  Icon(
                                    Icons.star,
                                    color: AppColors.secondary,
                                    size: 14.sp,
                                  ),
                                  AppSizes.p4.horizontalSpace,
                                  Text(
                                    rating,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ],
                      ).expanded(),
                      AppSizes.p8.horizontalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            price,
                            style: AppTextStyles.titleMedium.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AppSizes.p8.verticalSpace,
                          SizedBox(
                            height: 32.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                minimumSize: Size(0, 32.h),
                              ),
                              onPressed: () =>
                                  context.push(RouteNames.bookingConfirmation),
                              child: Text(
                                AppStrings.bookNow,
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).paddingSymmetric(horizontal: AppSizes.p16);
  }
}
