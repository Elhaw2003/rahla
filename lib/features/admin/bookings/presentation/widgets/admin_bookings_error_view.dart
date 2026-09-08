import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/shared/widgets/app_button.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/admin/bookings/presentation/cubit/admin_booking_cubit.dart';

class AdminBookingsErrorView extends StatelessWidget {
  final String error;

  const AdminBookingsErrorView({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              error,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.p16),
            AppButton(
              text: 'إعادة المحاولة',
              onPressed: () =>
                  context.read<AdminBookingCubit>().getAdminBookings(),
            ),
          ],
        ),
      ),
    );
  }
}
