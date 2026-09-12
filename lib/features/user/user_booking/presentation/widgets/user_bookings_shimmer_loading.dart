import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/shared/widgets/app_shimmer.dart';
import 'package:travel_app/core/theme/app_sizes.dart';

class UserBookingsShimmerLoading extends StatelessWidget {
  const UserBookingsShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSizes.p16),
        itemCount: 4,
        separatorBuilder: (_, _) => AppSizes.p12.verticalSpace,
        itemBuilder: (_, _) => const _BookingCardShimmer(),
      ),
    );
  }
}

class _BookingCardShimmer extends StatelessWidget {
  const _BookingCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                ),
              ),
              AppSizes.p12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14.h,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    AppSizes.p8.verticalSpace,
                    Container(height: 12.h, width: 120.w, color: Colors.white),
                    AppSizes.p8.verticalSpace,
                    Container(height: 10.h, width: 80.w, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
          AppSizes.p12.verticalSpace,
          Container(height: 1, color: Colors.white),
          AppSizes.p12.verticalSpace,
          Row(
            children: [
              Container(height: 14.h, width: 90.w, color: Colors.white),
              const Spacer(),
              Container(height: 12.h, width: 70.w, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}
