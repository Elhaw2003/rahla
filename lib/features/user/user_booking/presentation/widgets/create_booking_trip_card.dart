import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_assets.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/shared/widgets/app_network_image.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';

class CreateBookingTripCard extends StatelessWidget {
  final AdminTripModel trip;

  const CreateBookingTripCard({super.key, required this.trip});

  String _imageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return 'https://rahala.duckdns.org$path';
  }

  String _formatDate(String? raw) {
    final date = DateTime.tryParse(raw ?? '');
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year}';
  }

  String get _routeLabel {
    final origin = trip.origin?.trim() ?? '';
    final destination = trip.destination?.trim() ?? '';
    if (origin.isNotEmpty && destination.isNotEmpty) {
      return '$origin → $destination';
    }
    return destination.isNotEmpty ? destination : (trip.title ?? '');
  }

  String get _dateRange {
    final start = _formatDate(trip.startDate);
    final end = _formatDate(trip.endDate);
    if (start.isEmpty && end.isEmpty) return '';
    if (start.isNotEmpty && end.isNotEmpty) return '$start - $end';
    return start.isNotEmpty ? start : end;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _imageUrl(trip.coverImage);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.r16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.r16),
        child: SizedBox(
          height: 180.h,
          child: Stack(
            fit: StackFit.expand,
            children: [
              imageUrl.isNotEmpty
                  ? AppNetworkImage(
                      imageUrl: imageUrl,
                      width: double.infinity,
                      height: 180.h,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(AppAssets.homeFeatured, fit: BoxFit.cover),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.primaryDark.withValues(alpha: 0.85),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(AppSizes.p16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Text(
                      trip.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                    ),
                    AppSizes.p8.verticalSpace,
                    Row(
                      children: [
                        Icon(
                          Icons.route_rounded,
                          size: 14.sp,
                          color: AppColors.secondaryLight,
                        ),
                        AppSizes.p4.horizontalSpace,
                        Expanded(
                          child: Text(
                            _routeLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_dateRange.isNotEmpty) ...[
                      AppSizes.p4.verticalSpace,
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            size: 14.sp,
                            color: AppColors.secondaryLight,
                          ),
                          AppSizes.p4.horizontalSpace,
                          Text(
                            _dateRange,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                    AppSizes.p8.verticalSpace,
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.p12,
                        vertical: AppSizes.p4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(AppSizes.r16),
                      ),
                      child: Text(
                        '${AppStrings.tripDetailsAvailableSeats}: ${trip.availableSeats}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
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
