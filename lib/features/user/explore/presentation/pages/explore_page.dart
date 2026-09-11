import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/shared/widgets/app_shimmer.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/admin/trips/data/models/categories_response_model.dart';
import 'package:travel_app/features/admin/trips/presentation/cubit/categories_cubit.dart';
import 'package:travel_app/features/admin/trips/presentation/cubit/categories_states.dart';
import 'package:travel_app/features/user/explore/presentation/cubit/explore_cubit.dart';
import 'package:travel_app/features/user/explore/presentation/cubit/explore_states.dart';
import 'package:travel_app/features/user/explore/presentation/widgets/explore_categories_pinned_header.dart';
import 'package:travel_app/features/user/explore/presentation/widgets/explore_scroll_intro.dart';
import 'package:travel_app/features/user/explore/presentation/widgets/explore_shimmer_loading.dart';
import 'package:travel_app/features/user/explore/presentation/widgets/explore_trips_list.dart';

class ExplorePage extends StatefulWidget {
  final String initialCategorySlug;

  const ExplorePage({super.key, this.initialCategorySlug = ''});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late String _selectedCategorySlug;
  int _selectedCategoryIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _didAutoSelect = false;
  // final Map<int, double> _scrollPositions = {};

  @override
  void initState() {
    super.initState();
    _selectedCategorySlug = widget.initialCategorySlug;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 220) {
      context.read<ExploreCubit>().loadMoreTrips();
    }
  }

  String _categoryName(CategoryModel category) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (isArabic && category.nameAr?.isNotEmpty == true) {
      return category.nameAr!;
    }
    if (category.nameEn?.isNotEmpty == true) return category.nameEn!;
    return category.displayName;
  }

  void _loadCategory(String slug, int index, {bool forceRefresh = false}) {
    setState(() {
      _selectedCategorySlug = slug;
      _selectedCategoryIndex = index;
    });
    context.read<ExploreCubit>().getTripsFiltered(
      slug,
      index: index,
      forceRefresh: forceRefresh,
    );
  }

  void _onCategorySelected(CategoryModel category, int index) {
    final slug = category.slug ?? '';
    if (slug.isEmpty || slug == _selectedCategorySlug) return;
    // _scrollPositions[_selectedCategoryIndex] = _scrollController.offset;
    _loadCategory(slug, index);
  }

  Future<void> _onRefresh() async {
    if (_selectedCategorySlug.isEmpty) return;
    await context.read<ExploreCubit>().getTripsFiltered(
      _selectedCategorySlug,
      index: _selectedCategoryIndex,
      forceRefresh: true,
    );
  }

  void _maybeAutoSelect(List<CategoryModel> categories) {
    if (_didAutoSelect || categories.isEmpty) return;

    if (_selectedCategorySlug.isEmpty) {
      final firstSlug = categories.first.slug ?? '';
      if (firstSlug.isEmpty) return;
      _didAutoSelect = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _loadCategory(firstSlug, 0);
      });
      return;
    }

    final index = categories.indexWhere((c) => c.slug == _selectedCategorySlug);
    if (index < 0) {
      final firstSlug = categories.first.slug ?? '';
      if (firstSlug.isEmpty) return;
      _didAutoSelect = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _loadCategory(firstSlug, 0);
      });
    } else {
      _didAutoSelect = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _loadCategory(_selectedCategorySlug, index);
      });
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.primaryDark,
      foregroundColor: AppColors.surface,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryDark,
              AppColors.primary,
              Color(0xFF2A4060),
            ],
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        color: AppColors.secondaryLight,
        onPressed: () => context.pop(),
      ),
      title: Text(
        AppStrings.homeCategories,
        style: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.secondary,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
          fontSize: 22.sp,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesStates>(
      builder: (context, categoriesState) {
        final categories = categoriesState is CategoriesSuccess
            ? categoriesState.categories
            : const <CategoryModel>[];
        final isCategoriesLoading =
            categoriesState is CategoriesLoading ||
            categoriesState is CategoriesInitial;

        if (categoriesState is CategoriesSuccess) {
          _maybeAutoSelect(categories);
        }

        final selectedMatches = categories.where(
          (c) => c.slug == _selectedCategorySlug,
        );
        final selectedCategory = selectedMatches.isEmpty
            ? null
            : selectedMatches.first;

        //   listener: (context, exploreState) {
        //   if (exploreState is ExploreLoaded) {
        //     final savedPosition = _scrollPositions[_selectedCategoryIndex];

        //     if (savedPosition != null && _scrollController.hasClients) {
        //       WidgetsBinding.instance.addPostFrameCallback((_) {
        //         if (!mounted || !_scrollController.hasClients) return;

        //         final maxScroll = _scrollController.position.maxScrollExtent;

        //         _scrollController.jumpTo(savedPosition.clamp(0.0, maxScroll));
        //       });
        //     }
        //   }
        // },

        return BlocBuilder<ExploreCubit, ExploreStates>(
          builder: (context, exploreState) {
            final isExploreLoading =
                exploreState is ExploreLoading ||
                exploreState is ExploreInitial;
            final isFullLoading = isCategoriesLoading && isExploreLoading;

            final loaded = exploreState is ExploreLoaded ? exploreState : null;
            final tripsCount = isExploreLoading ? null : loaded?.total;

            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: _buildAppBar(),
              body: isFullLoading
                  ? const ExploreShimmerLoading()
                  : RefreshIndicator(
                      onRefresh: _onRefresh,
                      color: AppColors.secondary,
                      child: CustomScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: ExploreScrollIntro(
                              selectedCategoryName: selectedCategory == null
                                  ? null
                                  : _categoryName(selectedCategory),
                              tripsCount: tripsCount,
                            ),
                          ),
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: ExploreCategoriesPinnedHeader(
                              categories: categories,
                              selectedCategorySlug: _selectedCategorySlug,
                              onCategorySelected: _onCategorySelected,
                            ),
                          ),
                          if (exploreState is ExploreError)
                            ExploreErrorSliver(
                              message: exploreState.message,
                              onRetry: _onRefresh,
                            )
                          else if (isExploreLoading)
                            const SliverToBoxAdapter(
                              child: AppShimmer(child: ExploreTripsShimmer()),
                            )
                          else if (loaded != null)
                            ExploreTripsSliver(
                              trips: loaded.trips,
                              isLoadingMore: loaded.isLoadingMore,
                            )
                          else
                            const SliverToBoxAdapter(child: SizedBox.shrink()),
                        ],
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}
