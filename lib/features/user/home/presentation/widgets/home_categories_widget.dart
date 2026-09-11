import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/extensions/widget_extension.dart';
import 'package:travel_app/core/router/route_names.dart';
import 'package:travel_app/core/shared/widgets/app_network_image.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/admin/trips/data/models/categories_response_model.dart';

class HomeCategoriesWidget extends StatelessWidget {
  final List<CategoryModel> categories;

  const HomeCategoriesWidget({super.key, required this.categories});

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

  void _openExplore(BuildContext context, {String? categorySlug}) {
    final query = categorySlug == null || categorySlug.isEmpty
        ? RouteNames.explore
        : '${RouteNames.explore}?category=$categorySlug';
    context.push(query);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.homeCategories,
              style: AppTextStyles.titleMedium,
            ),
            GestureDetector(
              onTap: () => _openExplore(context),
              child: Text(
                AppStrings.viewAll,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: AppSizes.p16),
        AppSizes.p12.verticalSpace,
        SizedBox(
          height: 86.h,
          child: categories.isEmpty
              ? Center(
                  child: Text(
                    AppStrings.favoritesEmpty,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, _) => AppSizes.p12.horizontalSpace,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final imageUrl = _imageUrl(category.image);

                    return GestureDetector(
                      onTap: () =>
                          _openExplore(context, categorySlug: category.slug),
                      child: SizedBox(
                        width: 72.w,
                        child: Column(
                          children: [
                            Container(
                              width: 48.w,
                              height: 48.w,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.border),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: imageUrl.isNotEmpty
                                  ? AppNetworkImage(
                                      imageUrl: imageUrl,
                                      width: 48.w,
                                      height: 48.w,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      _fallbackIcon(category.slug),
                                      color: AppColors.primary,
                                      size: 20.sp,
                                    ),
                            ),
                            AppSizes.p8.verticalSpace,
                            Text(
                              _categoryName(category, context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
