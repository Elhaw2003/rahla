import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/shared/widgets/app_shimmer.dart';
import 'package:travel_app/core/theme/app_sizes.dart';

class NotificationsShimmerLoading extends StatelessWidget {
  const NotificationsShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSizes.p16),
        itemCount: 6,
        separatorBuilder: (_, _) => AppSizes.p12.verticalSpace,
        itemBuilder: (_, _) => const _NotificationCardShimmer(),
      ),
    );
  }
}

class _NotificationCardShimmer extends StatelessWidget {
  const _NotificationCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          AppSizes.p12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14.h, width: double.infinity, color: Colors.white),
                AppSizes.p8.verticalSpace,
                Container(height: 12.h, width: 200.w, color: Colors.white),
                AppSizes.p8.verticalSpace,
                Container(height: 10.h, width: 80.w, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
