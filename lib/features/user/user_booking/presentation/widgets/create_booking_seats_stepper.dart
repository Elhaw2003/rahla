import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';

class CreateBookingSeatsStepper extends StatelessWidget {
  final int seats;
  final int maxSeats;
  final num pricePerSeat;
  final ValueChanged<int> onChanged;

  const CreateBookingSeatsStepper({
    super.key,
    required this.seats,
    required this.maxSeats,
    required this.pricePerSeat,
    required this.onChanged,
  });

  String _formatPrice(num price) {
    return NumberFormat('#,###').format(price);
  }

  @override
  Widget build(BuildContext context) {
    final canDecrease = seats > 1;
    final canIncrease = seats < maxSeats;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.bookingConfirmationNumberOfIndividuals,
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        AppSizes.p12.verticalSpace,
        Container(
          padding: EdgeInsets.all(AppSizes.p16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.r16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              _RoundIconButton(
                icon: Icons.remove_rounded,
                enabled: canDecrease,
                onTap: () => onChanged(seats - 1),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '$seats',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    AppSizes.p4.verticalSpace,
                    Text(
                      '${_formatPrice(pricePerSeat)} ${AppStrings.currencyEGP} / ${AppStrings.bookingConfirmationPerPerson}',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _RoundIconButton(
                icon: Icons.add_rounded,
                enabled: canIncrease,
                onTap: () => onChanged(seats + 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _RoundIconButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled
          ? AppColors.primary.withValues(alpha: 0.08)
          : AppColors.disabled.withValues(alpha: 0.25),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onTap : null,
        child: SizedBox(
          width: 44.w,
          height: 44.w,
          child: Icon(
            icon,
            size: 22.sp,
            color: enabled ? AppColors.primary : AppColors.textHint,
          ),
        ),
      ),
    );
  }
}
