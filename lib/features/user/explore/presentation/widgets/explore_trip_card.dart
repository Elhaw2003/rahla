import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/core/constants/app_assets.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/router/route_names.dart';
import 'package:travel_app/core/shared/widgets/app_network_image.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';

class ExploreTripCard extends StatelessWidget {
  final AdminTripModel trip;

  const ExploreTripCard({super.key, required this.trip});

  String _imageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return 'https://rahala.duckdns.org$path';
  }

  String _formatPrice(num price) {
    return NumberFormat('#,###').format(price);
  }

  String get _routeLabel {
    final origin = trip.origin?.trim() ?? '';
    final destination = trip.destination?.trim() ?? '';
    if (origin.isNotEmpty && destination.isNotEmpty) {
      return '$origin → $destination';
    }
    return destination.isNotEmpty ? destination : (trip.title ?? '');
  }

  String? _categoryLabel(BuildContext context) {
    final category = trip.category;
    if (category == null) return null;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (isArabic && category.nameAr?.isNotEmpty == true) {
      return category.nameAr;
    }
    if (category.nameEn?.isNotEmpty == true) return category.nameEn;
    return category.nameAr;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _imageUrl(trip.coverImage);
    final categoryLabel = _categoryLabel(context);

    return GestureDetector(
      onTap: () => context.push(RouteNames.tripDetails),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.r16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 168.h,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  imageUrl.isNotEmpty
                      ? AppNetworkImage(
                          imageUrl: imageUrl,
                          width: double.infinity,
                          height: 168.h,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          AppAssets.homeFeatured,
                          fit: BoxFit.cover,
                        ),
                  Positioned(
                    top: AppSizes.p12,
                    right: AppSizes.p12,
                    child: Container(
                      padding: EdgeInsets.all(AppSizes.p8),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.95),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        trip.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 16.sp,
                        color: trip.isFavorite
                            ? AppColors.error
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  if (categoryLabel != null && categoryLabel.isNotEmpty)
                    Positioned(
                      top: AppSizes.p12,
                      left: AppSizes.p12,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.p12,
                          vertical: AppSizes.p4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.88),
                          borderRadius: BorderRadius.circular(AppSizes.r16),
                        ),
                        child: Text(
                          categoryLabel,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.surface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSizes.p12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  AppSizes.p8.verticalSpace,
                  Row(
                    children: [
                      Icon(
                        Icons.route_rounded,
                        size: 15.sp,
                        color: AppColors.secondary,
                      ),
                      AppSizes.p4.horizontalSpace,
                      Expanded(
                        child: Text(
                          _routeLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (trip.description?.isNotEmpty == true) ...[
                    AppSizes.p8.verticalSpace,
                    Text(
                      trip.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textHint,
                        height: 1.35,
                      ),
                    ),
                  ],
                  AppSizes.p12.verticalSpace,
                  const Divider(height: 1, color: AppColors.divider),
                  AppSizes.p12.verticalSpace,
                  Row(
                    children: [
                      if (trip.averageRating > 0) ...[
                        Icon(
                          Icons.star_rounded,
                          size: 16.sp,
                          color: AppColors.secondary,
                        ),
                        AppSizes.p4.horizontalSpace,
                        Text(
                          trip.averageRating.toStringAsFixed(1),
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (trip.reviewsCount > 0)
                          Text(
                            ' (${trip.reviewsCount})',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textHint,
                            ),
                          ),
                        AppSizes.p12.horizontalSpace,
                      ],
                      Icon(
                        Icons.event_seat_outlined,
                        size: 15.sp,
                        color: AppColors.textSecondary,
                      ),
                      AppSizes.p4.horizontalSpace,
                      Text(
                        '${trip.availableSeats}',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${_formatPrice(trip.price)} ${AppStrings.currencyEGP}',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
