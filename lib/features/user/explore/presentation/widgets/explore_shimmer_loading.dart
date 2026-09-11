import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/shared/widgets/app_shimmer.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/features/user/explore/presentation/widgets/explore_categories_bar.dart';

/// Full-page explore shimmer: intro + categories + trip cards.
/// Mirrors success layout (without AppBar).
class ExploreShimmerLoading extends StatelessWidget {
  const ExploreShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            ExploreIntroShimmer(),
            ExploreCategoriesShimmer(),
            ExploreTripsShimmer(),
          ],
        ),
      ),
    );
  }
}

/// Mirrors [ExploreScrollIntro]: title + trips count.
class ExploreIntroShimmer extends StatelessWidget {
  const ExploreIntroShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.p16,
        AppSizes.p16,
        AppSizes.p16,
        AppSizes.p8,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSizes.p16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.r16),
          // Border only — no fill, so it doesn't become one solid shimmer block.
          border: Border.all(color: Colors.white),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppShimmerBone(width: 160.w, height: 18.h, borderRadius: 8),
            AppSizes.p8.verticalSpace,
            AppShimmerBone(width: 72.w, height: 12.h, borderRadius: 6),
          ],
        ),
      ),
    );
  }
}

/// Mirrors [ExploreCategoriesBar]: chip card + icon circle + label.
class ExploreCategoriesShimmer extends StatelessWidget {
  const ExploreCategoriesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ExploreCategoriesBar.barHeight,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p16,
          vertical: AppSizes.p8,
        ),
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (_, _) => AppSizes.p8.horizontalSpace,
        itemBuilder: (_, _) => const _CategoryChipShimmer(),
      ),
    );
  }
}

class _CategoryChipShimmer extends StatelessWidget {
  const _CategoryChipShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72.w,
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p4,
        vertical: AppSizes.p4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.r16),
        // Outline only — keeps chip shape without filling the whole card.
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppShimmerBone.circle(size: 32.w),
          SizedBox(height: 4.h),
          AppShimmerBone(width: 48.w, height: 10.h, borderRadius: 6),
        ],
      ),
    );
  }
}

class ExploreTripsShimmer extends StatelessWidget {
  final int itemCount;

  const ExploreTripsShimmer({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.p16,
        AppSizes.p8,
        AppSizes.p16,
        AppSizes.p24,
      ),
      child: Column(
        children: List.generate(itemCount, (index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == itemCount - 1 ? 0 : AppSizes.p16,
            ),
            child: const ExploreTripCardShimmer(),
          );
        }),
      ),
    );
  }
}

/// Mirrors [ExploreTripCard]: image + overlays + title/route/desc + footer.
class ExploreTripCardShimmer extends StatelessWidget {
  const ExploreTripCardShimmer({super.key});

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
                // Title
                AppShimmerBone(width: 120.w, height: 16.h, borderRadius: 8),
                AppSizes.p8.verticalSpace,
                // Route: icon + text
                Row(
                  children: [
                    AppShimmerBone.circle(size: 15.w),
                    AppSizes.p4.horizontalSpace,
                    AppShimmerBone(width: 140.w, height: 12.h, borderRadius: 6),
                  ],
                ),
                AppSizes.p8.verticalSpace,
                // Description
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
                // Footer: seats + price (matches success row)
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
