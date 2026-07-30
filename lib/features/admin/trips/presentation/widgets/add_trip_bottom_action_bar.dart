import 'package:flutter/material.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/shared/widgets/app_button.dart';
import 'package:travel_app/core/theme/app_sizes.dart';

class AddTripBottomActionBar extends StatelessWidget {
  final int currentStep;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool isLoading;

  const AddTripBottomActionBar({
    super.key,
    required this.currentStep,
    required this.onPrevious,
    required this.onNext,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (currentStep > 0) ...[
            Expanded(
              child: AppButton.outlined(
                text: AppStrings.adminPreviousStep,
                onPressed: isLoading ? null : onPrevious,
              ),
            ),
            SizedBox(width: AppSizes.p12),
          ],
          Expanded(
            child: AppButton(
              text: currentStep == 3
                  ? AppStrings.adminPublishTrip
                  : AppStrings.adminNextStep,
              isLoading: isLoading,
              onPressed: isLoading ? null : onNext,
            ),
          ),
        ],
      ),
    );
  }
}
