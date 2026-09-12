import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/user/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:travel_app/features/user/favorites/presentation/cubit/favorites_states.dart';
import 'package:travel_app/features/user/favorites/presentation/widgets/favorites_empty_view.dart';
import 'package:travel_app/features/user/favorites/presentation/widgets/favorites_error_view.dart';
import 'package:travel_app/features/user/favorites/presentation/widgets/favorites_header.dart';
import 'package:travel_app/features/user/favorites/presentation/widgets/favorites_list.dart';
import 'package:travel_app/features/user/favorites/presentation/widgets/favorites_shimmer_loading.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<FavoritesCubit>().getFavorites();
    });
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
        _scrollController.position.maxScrollExtent - 200) {
      context.read<FavoritesCubit>().loadMoreFavorites();
    }
  }

  Future<void> _onRefresh() async {
    await context.read<FavoritesCubit>().getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          color: AppColors.textPrimary,
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppStrings.favoritesTitle,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesStates>(
        builder: (context, state) {
          if (state is FavoritesLoading || state is FavoritesInitial) {
            return const FavoritesShimmerLoading();
          }

          if (state is FavoritesError) {
            return FavoritesErrorView(
              message: state.message,
              onRetry: () => context.read<FavoritesCubit>().getFavorites(),
            );
          }

          if (state is FavoritesLoaded) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.secondary,
              child: Column(
                children: [
                  FavoritesHeader(totalItems: state.totalItems),
                  Expanded(
                    child: state.favorites.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(height: 80),
                              FavoritesEmptyView(),
                            ],
                          )
                        : FavoritesList(
                            favorites: state.favorites,
                            isLoadingMore: state.isLoadingMore,
                            scrollController: _scrollController,
                          ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
