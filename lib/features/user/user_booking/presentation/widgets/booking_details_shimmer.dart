import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/shared/widgets/app_shimmer.dart';
import 'package:travel_app/core/theme/app_sizes.dart';

class BookingDetailsShimmer extends StatelessWidget {
  const BookingDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSizes.p16),
        child: Column(
          children: [
            Container(
              height: 220.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.r24),
              ),
            ),
            AppSizes.p16.verticalSpace,
            Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.r24),
              ),
            ),
            AppSizes.p16.verticalSpace,
            Container(
              height: 160.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSizes.r24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
