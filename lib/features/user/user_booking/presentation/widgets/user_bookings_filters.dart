import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';

enum UserBookingsFilter { all, approved, pending, cancelled }

class UserBookingsFilters extends StatelessWidget {
  final UserBookingsFilter selected;
  final ValueChanged<UserBookingsFilter> onSelected;

  const UserBookingsFilters({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = <(UserBookingsFilter, String)>[
      (UserBookingsFilter.all, AppStrings.bookingsFilterAll),
      (UserBookingsFilter.approved, AppStrings.bookingsFilterAccepted),
      (UserBookingsFilter.pending, AppStrings.bookingsFilterPending),
      (UserBookingsFilter.cancelled, AppStrings.bookingsFilterCancelled),
    ];

    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => AppSizes.p8.horizontalSpace,
        itemBuilder: (context, index) {
          final (filter, label) = items[index];
          final isSelected = selected == filter;
          return GestureDetector(
            onTap: () => onSelected(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.r24),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
