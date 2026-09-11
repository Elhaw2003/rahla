import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/shared/widgets/app_button.dart';
import 'package:travel_app/core/shared/widgets/app_loading.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';
import 'package:travel_app/features/user/explore/presentation/widgets/explore_trip_card.dart';

class ExploreTripsSliver extends StatelessWidget {
  final List<AdminTripModel> trips;
  final bool isLoadingMore;

  const ExploreTripsSliver({
    super.key,
    required this.trips,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: ExploreEmptyView(),
      );
    }

    final itemCount = trips.length + (isLoadingMore ? 1 : 0);

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.p16,
        AppSizes.p8,
        AppSizes.p16,
        AppSizes.p24,
      ),
      sliver: SliverList.separated(
        itemCount: itemCount,
        separatorBuilder: (_, _) => AppSizes.p16.verticalSpace,
        itemBuilder: (context, index) {
          if (index >= trips.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: AppSizes.p12),
              child: const AppLoading(size: 28),
            );
          }
          return ExploreTripCard(trip: trips[index]);
        },
      ),
    );
  }
}

class ExploreEmptyView extends StatelessWidget {
  const ExploreEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSizes.p24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.travel_explore_rounded,
            size: 56.sp,
            color: AppColors.secondary,
          ),
          AppSizes.p16.verticalSpace,
          Text(
            AppStrings.exploreEmptyTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.titleMedium,
          ),
          AppSizes.p8.verticalSpace,
          Text(
            AppStrings.exploreEmptySubtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class ExploreErrorSliver extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ExploreErrorSliver({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSizes.p16.verticalSpace,
            AppButton(text: AppStrings.exploreRetry, onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
