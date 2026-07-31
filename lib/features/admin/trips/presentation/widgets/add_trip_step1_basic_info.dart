import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_cities.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/shared/widgets/app_loading.dart';
import 'package:travel_app/core/shared/widgets/app_text_field.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/admin/trips/data/models/categories_response_model.dart';

class AddTripStep1BasicInfo extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final List<CategoryModel> categories;
  final bool isCategoriesLoading;
  final String? selectedCategoryId;
  final String? selectedOrigin;
  final String? selectedDestination;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onOriginChanged;
  final ValueChanged<String?> onDestinationChanged;

  const AddTripStep1BasicInfo({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.categories,
    required this.isCategoriesLoading,
    required this.selectedCategoryId,
    required this.selectedOrigin,
    required this.selectedDestination,
    required this.onCategoryChanged,
    required this.onOriginChanged,
    required this.onDestinationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: titleController,
          labelText: AppStrings.adminTripTitleLabel,
          hintText: AppStrings.adminTripTitleHint,
        ),
        AppSizes.p16.verticalSpace,
        AppTextField(
          controller: descriptionController,
          labelText: AppStrings.adminTripDescLabel,
          hintText: AppStrings.adminTripDescHint,
          type: AppTextFieldType.multiline,
        ),
        AppSizes.p16.verticalSpace,
        if (isCategoriesLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: AppLoading(size: 28),
          )
        else
          _buildDropdown<String>(
            label: AppStrings.adminCategoryLabel,
            hint: AppStrings.adminCategoryHint,
            value: selectedCategoryId,
            items: categories
                .where((c) => c.id != null && c.id!.isNotEmpty)
                .map(
                  (category) => DropdownMenuItem<String>(
                    value: category.id,
                    child: Text(category.displayName),
                  ),
                )
                .toList(),
            onChanged: onCategoryChanged,
          ),
        AppSizes.p16.verticalSpace,
        _buildDropdown<String>(
          label: AppStrings.adminOriginLabel,
          hint: AppStrings.adminOriginHint,
          value: selectedOrigin,
          items: AppCities.cities
              .map(
                (city) => DropdownMenuItem<String>(
                  value: city.value,
                  child: Text(city.labelAr),
                ),
              )
              .toList(),
          onChanged: onOriginChanged,
        ),
        AppSizes.p16.verticalSpace,
        _buildDropdown<String>(
          label: AppStrings.adminDestinationLabel,
          hint: AppStrings.adminDestinationHint,
          value: selectedDestination,
          items: AppCities.cities
              .map(
                (city) => DropdownMenuItem<String>(
                  value: city.value,
                  child: Text(city.labelAr),
                ),
              )
              .toList(),
          onChanged: onDestinationChanged,
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required String hint,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      isExpanded: true,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.textSecondary,
        size: 22.sp,
      ),
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(labelText: label, hintText: hint),
    );
  }
}
