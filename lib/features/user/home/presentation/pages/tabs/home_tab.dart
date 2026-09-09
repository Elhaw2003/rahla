import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/extensions/widget_extension.dart';
import 'package:travel_app/core/shared/widgets/app_button.dart';
import 'package:travel_app/core/shared/widgets/app_loading.dart';
import 'package:travel_app/core/shared/widgets/app_snackbar.dart';
import 'package:travel_app/core/shared/widgets/app_text_field.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/admin/trips/presentation/cubit/categories_cubit.dart';
import 'package:travel_app/features/user/home/presentation/cubit/home_cubit.dart';
import 'package:travel_app/features/user/home/presentation/cubit/home_states.dart';
import 'package:travel_app/features/user/home/presentation/widgets/home_categories_widget.dart';
import 'package:travel_app/features/user/home/presentation/widgets/home_featured_banner_widget.dart';
import 'package:travel_app/features/user/home/presentation/widgets/home_header_widget.dart';
import 'package:travel_app/features/user/home/presentation/widgets/home_popular_destinations_widget.dart';
import 'package:travel_app/features/user/home/presentation/widgets/home_promo_banner_widget.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<HomeCubit>().loadHome();
      context.read<CategoriesCubit>().getCategories();
    });
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      context.read<HomeCubit>().loadHome(),
      context.read<CategoriesCubit>().getCategories(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is HomeError) {
          AppSnackbar.showError(context: context, message: state.message);
        }
      },
      builder: (context, state) {
        if (state is HomeLoading || state is HomeInitial) {
          return const AppLoading();
        }

        if (state is HomeError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.p24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSizes.p16.verticalSpace,
                  AppButton(
                    text: 'إعادة المحاولة',
                    onPressed: _onRefresh,
                  ),
                ],
              ),
            ),
          );
        }

        final success = state is HomeSuccess ? state : null;
        final trips = success?.trips ?? const [];
        final offers = success?.offers ?? const [];
        final featuredTrip = trips.isNotEmpty ? trips.first : null;
        final activeOffer = offers.isNotEmpty
            ? offers.firstWhere(
                (offer) => offer.isActive,
                orElse: () => offers.first,
              )
            : null;

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const HomeHeaderWidget(),
                AppTextField(
                  hintText: AppStrings.searchHint,
                  type: AppTextFieldType.search,
                ).paddingSymmetric(horizontal: AppSizes.p16),
                AppSizes.p16.verticalSpace,
                HomeFeaturedBannerWidget(trip: featuredTrip),
                AppSizes.p16.verticalSpace,
                const HomeCategoriesWidget(),
                AppSizes.p16.verticalSpace,
                HomePopularDestinationsWidget(
                  trips: trips,
                  hasMore: success?.hasMore ?? false,
                  isLoadingMore: success?.isLoading ?? false,
                  onLoadMore: () {
                    context.read<HomeCubit>().fetchMoreTrips();
                  },
                ),
                AppSizes.p16.verticalSpace,
                HomePromoBannerWidget(offer: activeOffer),
                AppSizes.p16.verticalSpace,
              ],
            ),
          ),
        );
      },
    );
  }
}
