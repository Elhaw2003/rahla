import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/shared/widgets/app_shimmer.dart';
import 'package:travel_app/core/theme/app_sizes.dart';

class FavoritesShimmerLoading extends StatelessWidget {
  const FavoritesShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          AppSizes.p16,
          AppSizes.p8,
          AppSizes.p16,
          AppSizes.p24,
        ),
        itemCount: 3,
        separatorBuilder: (_, _) => AppSizes.p16.verticalSpace,
        itemBuilder: (_, _) => const _FavoriteCardShimmer(),
      ),
    );
  }
}

class _FavoriteCardShimmer extends StatelessWidget {
  const _FavoriteCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(color: Colors.white),
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
                AppShimmerBone(
                  width: double.infinity,
                  height: 168.h,
                  borderRadius: 0,
                ),
                Positioned(
                  top: AppSizes.p12,
                  right: AppSizes.p12,
                  child: AppShimmerBone.circle(size: 32.w),
                ),
                Positioned(
                  top: AppSizes.p12,
                  left: AppSizes.p12,
                  child: AppShimmerBone(
                    width: 88.w,
                    height: 22.h,
                    borderRadius: AppSizes.r16,
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
                AppShimmerBone(width: 160.w, height: 16.h, borderRadius: 8),
                AppSizes.p8.verticalSpace,
                Row(
                  children: [
                    AppShimmerBone.circle(size: 15.w),
                    AppSizes.p4.horizontalSpace,
                    AppShimmerBone(width: 140.w, height: 12.h, borderRadius: 6),
                  ],
                ),
                AppSizes.p8.verticalSpace,
                AppShimmerBone(
                  width: double.infinity,
                  height: 12.h,
                  borderRadius: 6,
                ),
                AppSizes.p4.verticalSpace,
                AppShimmerBone(width: 200.w, height: 12.h, borderRadius: 6),
                AppSizes.p12.verticalSpace,
                AppShimmerBone(
                  width: double.infinity,
                  height: 1,
                  borderRadius: 0,
                ),
                AppSizes.p12.verticalSpace,
                Row(
                  children: [
                    AppShimmerBone.circle(size: 15.w),
                    AppSizes.p4.horizontalSpace,
                    AppShimmerBone(width: 28.w, height: 12.h, borderRadius: 6),
                    const Spacer(),
                    AppShimmerBone(width: 72.w, height: 14.h, borderRadius: 7),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
