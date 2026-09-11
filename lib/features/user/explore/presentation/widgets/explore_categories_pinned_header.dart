import 'package:flutter/material.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/features/admin/trips/data/models/categories_response_model.dart';
import 'package:travel_app/features/user/explore/presentation/widgets/explore_categories_bar.dart';

class ExploreCategoriesPinnedHeader extends SliverPersistentHeaderDelegate {
  final List<CategoryModel> categories;
  final String selectedCategorySlug;
  final void Function(CategoryModel category, int index) onCategorySelected;

  ExploreCategoriesPinnedHeader({
    required this.categories,
    required this.selectedCategorySlug,
    required this.onCategorySelected,
  });

  @override
  double get minExtent => ExploreCategoriesBar.barHeight;

  @override
  double get maxExtent => ExploreCategoriesBar.barHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: AppColors.surface,
      elevation: overlapsContent || shrinkOffset > 0 ? 1.5 : 0,
      shadowColor: AppColors.primary.withValues(alpha: 0.1),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: ExploreCategoriesBar(
          categories: categories,
          selectedCategorySlug: selectedCategorySlug,
          onCategorySelected: onCategorySelected,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant ExploreCategoriesPinnedHeader oldDelegate) {
    return oldDelegate.selectedCategorySlug != selectedCategorySlug ||
        oldDelegate.categories != categories ||
        oldDelegate.onCategorySelected != onCategorySelected;
  }
}
