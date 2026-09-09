import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/extensions/widget_extension.dart';
import 'package:travel_app/core/shared/widgets/app_shimmer.dart';
import 'package:travel_app/core/theme/app_sizes.dart';

class HomeShimmerLoading extends StatefulWidget {
  const HomeShimmerLoading({super.key});

  @override
  State<HomeShimmerLoading> createState() => _HomeShimmerLoadingState();
}

class _HomeShimmerLoadingState extends State<HomeShimmerLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _sectionAnim(int index) {
    final start = (index * 0.12).clamp(0.0, 0.7);
    final end = (start + 0.35).clamp(0.0, 1.0);
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
  }

  Widget _stagger({required int index, required Widget child}) {
    return FadeTransition(
      opacity: _sectionAnim(index),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(_sectionAnim(index)),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: AppSizes.p24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stagger(index: 0, child: _buildHeader()),
            _stagger(index: 1, child: _buildSearch()),
            AppSizes.p16.verticalSpace,
            _stagger(index: 2, child: _buildFeaturedBanner()),
            AppSizes.p16.verticalSpace,
            _stagger(index: 3, child: _buildSectionTitle()),
            AppSizes.p12.verticalSpace,
            _stagger(index: 4, child: _buildCategories()),
            AppSizes.p16.verticalSpace,
            _stagger(index: 5, child: _buildSectionTitle()),
            AppSizes.p12.verticalSpace,
            _stagger(index: 6, child: _buildDestinations()),
            AppSizes.p16.verticalSpace,
            _stagger(index: 7, child: _buildPromo()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSizes.p16, AppSizes.p8, AppSizes.p16, 0),
      child: Row(
        children: [
          const AppShimmerBone.circle(size: 40),
          AppSizes.p12.horizontalSpace,
          AppShimmerBone(width: 120.w, height: 18.h, borderRadius: 8),
          const Spacer(),
          const AppShimmerBone.circle(size: 36),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSizes.p16, AppSizes.p16, AppSizes.p16, 0),
      child: AppShimmerBone(
        width: double.infinity,
        height: 48.h,
        borderRadius: AppSizes.r12,
      ),
    );
  }

  Widget _buildFeaturedBanner() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
      child: Container(
        height: 140.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.r16),
        ),
        padding: EdgeInsets.all(AppSizes.p16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmerBone(width: 110.w, height: 18.h, borderRadius: 8),
                    AppSizes.p8.verticalSpace,
                    AppShimmerBone(width: 150.w, height: 12.h, borderRadius: 6),
                  ],
                ).expanded(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppShimmerBone(width: 72.w, height: 16.h, borderRadius: 8),
                    AppSizes.p8.verticalSpace,
                    AppShimmerBone(width: 80.w, height: 28.h, borderRadius: 10),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppShimmerBone(width: 120.w, height: 16.h, borderRadius: 8),
          AppShimmerBone(width: 48.w, height: 12.h, borderRadius: 6),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 86.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (_, _) => AppSizes.p12.horizontalSpace,
        itemBuilder: (_, _) {
          return SizedBox(
            width: 72.w,
            child: Column(
              children: [
                const AppShimmerBone.circle(size: 48),
                AppSizes.p8.verticalSpace,
                AppShimmerBone(width: 52.w, height: 10.h, borderRadius: 6),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDestinations() {
    return SizedBox(
      height: 160.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (_, _) => AppSizes.p12.horizontalSpace,
        itemBuilder: (_, index) {
          return Container(
            width: 120.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.r16),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmerBone(
                  width: double.infinity,
                  height: 90.h,
                  borderRadius: AppSizes.r16,
                ),
                Padding(
                  padding: EdgeInsets.all(AppSizes.p12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppShimmerBone(
                        width: 70.w + (index * 4).w,
                        height: 12.h,
                        borderRadius: 6,
                      ),
                      AppSizes.p8.verticalSpace,
                      AppShimmerBone(width: 54.w, height: 12.h, borderRadius: 6),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPromo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
      child: Container(
        height: 120.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.r16),
        ),
        padding: EdgeInsets.all(AppSizes.p16),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppShimmerBone(width: 160.w, height: 16.h, borderRadius: 8),
                AppSizes.p8.verticalSpace,
                AppShimmerBone(width: 200.w, height: 12.h, borderRadius: 6),
                AppSizes.p12.verticalSpace,
                AppShimmerBone(width: 88.w, height: 30.h, borderRadius: 10),
              ],
            ).expanded(),
            AppShimmerBone(width: 48.w, height: 36.h, borderRadius: 10),
          ],
        ),
      ),
    );
  }
}
