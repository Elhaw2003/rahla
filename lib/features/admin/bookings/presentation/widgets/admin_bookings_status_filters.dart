import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/admin/bookings/presentation/cubit/admin_booking_cubit.dart';

class AdminBookingsStatusFilters extends StatelessWidget {
  static const statuses = ['all', 'pending', 'approved', 'rejected'];

  final String selectedStatus;
  final int allCount;
  final int pendingCount;
  final int approvedCount;
  final int rejectedCount;

  const AdminBookingsStatusFilters({
    super.key,
    required this.selectedStatus,
    required this.allCount,
    required this.pendingCount,
    required this.approvedCount,
    required this.rejectedCount,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      '${AppStrings.bookingsFilterAll} ($allCount)',
      '${AppStrings.adminFilterPending} ($pendingCount)',
      '${AppStrings.adminFilterAccepted} ($approvedCount)',
      '${AppStrings.adminFilterRejected} ($rejectedCount)',
    ];
    final selectedIndex = statuses.indexOf(selectedStatus);
    final safeIndex = selectedIndex < 0 ? 0 : selectedIndex;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
        child: Row(
          children: List.generate(
            tabs.length,
            (index) => _AdminBookingsFilterTab(
              label: tabs[index],
              isSelected: safeIndex == index,
              onTap: () {
                context.read<AdminBookingCubit>().selectStatus(statuses[index]);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminBookingsFilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AdminBookingsFilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p16,
          vertical: AppSizes.p12,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
