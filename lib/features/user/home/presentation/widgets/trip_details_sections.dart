import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_assets.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/extensions/widget_extension.dart';
import 'package:travel_app/core/shared/widgets/app_network_image.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';

class TripDetailsItinerary extends StatelessWidget {
  final List<AdminTripDay> days;
  final Set<int> expandedDayIndexes;
  final ValueChanged<int> onToggleDay;

  const TripDetailsItinerary({
    super.key,
    required this.days,
    required this.expandedDayIndexes,
    required this.onToggleDay,
  });

  String _imageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return 'https://rahala.duckdns.org$path';
  }

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return Text(
        AppStrings.favoritesEmpty,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      );
    }

    return Column(
      children: List.generate(days.length, (index) {
        final day = days[index];
        final isExpanded = expandedDayIndexes.contains(index);
        final title = day.title?.isNotEmpty == true
            ? '${AppStrings.tripDetailsDay} ${day.dayNumber} — ${day.title}'
            : '${AppStrings.tripDetailsDay} ${day.dayNumber}';

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == days.length - 1 ? 0 : AppSizes.p16,
          ),
          child: _Accordion(
            title: title,
            isExpanded: isExpanded,
            onTap: () => onToggleDay(index),
            child: day.activities.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.only(
                      top: AppSizes.p24,
                      right: AppSizes.p12,
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            width: 2.w,
                            child: Container(color: AppColors.divider),
                          ),
                          AppSizes.p16.horizontalSpace,
                          Expanded(
                            child: Column(
                              children: List.generate(day.activities.length, (
                                activityIndex,
                              ) {
                                final activity = day.activities[activityIndex];
                                final imageUrl = _imageUrl(activity.image);
                                return _TimelineEvent(
                                  time: activity.time ?? '',
                                  title: activity.title ?? '',
                                  description: activity.description ?? '',
                                  imageUrl: imageUrl.isEmpty ? null : imageUrl,
                                  isLast:
                                      activityIndex ==
                                      day.activities.length - 1,
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      }),
    );
  }
}

class _Accordion extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onTap;
  final Widget child;

  const _Accordion({
    required this.title,
    required this.isExpanded,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(AppSizes.p16),
            decoration: BoxDecoration(
              color: isExpanded ? AppColors.surface : Colors.white,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppSizes.r12),
            ),
            child: Row(
              children: [
                Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.border),
                    shape: BoxShape.circle,
                  ),
                  child: isExpanded
                      ? Icon(
                          Icons.check,
                          size: 14.sp,
                          color: AppColors.primary,
                        )
                      : null,
                ),
                AppSizes.p12.horizontalSpace,
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) child,
      ],
    );
  }
}

class _TimelineEvent extends StatelessWidget {
  final String time;
  final String title;
  final String description;
  final String? imageUrl;
  final bool isLast;

  const _TimelineEvent({
    required this.time,
    required this.title,
    required this.description,
    this.imageUrl,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSizes.p32),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -24.w,
            top: 0,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppColors.border,
                border: Border.all(color: Colors.white, width: 2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (time.isNotEmpty)
                SizedBox(
                  width: 60.w,
                  child: Text(
                    time,
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  if (description.isNotEmpty) ...[
                    AppSizes.p4.verticalSpace,
                    Text(
                      description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ).expanded(),
              if (imageUrl != null) ...[
                AppSizes.p16.horizontalSpace,
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                  child: AppNetworkImage(
                    imageUrl: imageUrl!,
                    width: 80.w,
                    height: 80.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class TripDetailsBulletList extends StatelessWidget {
  final List<String> items;
  final Color bulletColor;

  const TripDetailsBulletList({
    super.key,
    required this.items,
    this.bulletColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text(
        '—',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      );
    }

    return Column(
      children: items.map((item) {
        return Padding(
          padding: EdgeInsets.only(bottom: AppSizes.p12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 6.h),
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: bulletColor,
                  shape: BoxShape.circle,
                ),
              ),
              AppSizes.p12.horizontalSpace,
              Expanded(
                child: Text(
                  item,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class TripDetailsGalleryGrid extends StatelessWidget {
  final List<String> images;

  const TripDetailsGalleryGrid({super.key, required this.images});

  String _imageUrl(String path) {
    if (path.startsWith('http')) return path;
    return 'https://rahala.duckdns.org$path';
  }

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Text(
        AppStrings.tripDetailsNoGallery,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSizes.p12,
        mainAxisSpacing: AppSizes.p12,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        final url = _imageUrl(images[index]);
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          child: url.isEmpty
              ? Image.asset(AppAssets.homeFeatured, fit: BoxFit.cover)
              : AppNetworkImage(
                  imageUrl: url,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
        );
      },
    );
  }
}
