import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/shared/widgets/app_network_image.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/admin/trips/data/models/categories_response_model.dart';

class ExploreCategoriesBar extends StatelessWidget {
  final List<CategoryModel> categories;
  final String selectedCategorySlug;
  final void Function(CategoryModel category, int index) onCategorySelected;

  static double get barHeight => 88.h;

  const ExploreCategoriesBar({
    super.key,
    required this.categories,
    required this.selectedCategorySlug,
    required this.onCategorySelected,
  });

  String _imageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return 'https://rahala.duckdns.org$path';
  }

  String _categoryName(CategoryModel category, BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (isArabic && category.nameAr?.isNotEmpty == true) {
      return category.nameAr!;
    }
    if (category.nameEn?.isNotEmpty == true) return category.nameEn!;
    return category.displayName;
  }

  IconData _fallbackIcon(String? slug) {
    switch (slug?.toLowerCase()) {
      case 'beach':
      case 'beaches':
      case 'beach-vacations':
        return Icons.beach_access;
      case 'historical':
      case 'history':
        return Icons.account_balance;
      case 'mountain':
      case 'mountains':
        return Icons.landscape;
      case 'safari':
        return Icons.directions_car;
      case 'family':
        return Icons.family_restroom;
      case 'camping':
        return Icons.cabin;
      default:
        return Icons.category_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return SizedBox(height: ExploreCategoriesBar.barHeight);
    }

    return Container(
      height: ExploreCategoriesBar.barHeight,
      color: AppColors.surface,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p16,
          vertical: AppSizes.p8,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => AppSizes.p8.horizontalSpace,
        itemBuilder: (context, index) {
          final category = categories[index];
          final slug = category.slug ?? '';
          final isSelected = slug.isNotEmpty && slug == selectedCategorySlug;
          final imageUrl = _imageUrl(category.image);

          return GestureDetector(
            onTap: () => onCategorySelected(category, index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: 72.w,
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.p4,
                vertical: AppSizes.p4,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.r16),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? AppColors.surface.withValues(alpha: 0.18)
                          : AppColors.background,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.secondaryLight
                            : AppColors.border,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: imageUrl.isNotEmpty
                        ? AppNetworkImage(
                            imageUrl: imageUrl,
                            width: 32.w,
                            height: 32.w,
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            _fallbackIcon(category.slug),
                            size: 16.sp,
                            color: isSelected
                                ? AppColors.secondaryLight
                                : AppColors.primary,
                          ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _categoryName(category, context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.labelSmall.copyWith(
                      fontSize: 10.sp,
                      height: 1.1,
                      color: isSelected
                          ? AppColors.surface
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
