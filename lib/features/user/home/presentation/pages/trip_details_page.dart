import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/router/route_names.dart';
import 'package:travel_app/core/shared/widgets/app_snackbar.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';
import 'package:travel_app/features/user/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:travel_app/features/user/favorites/presentation/cubit/favorites_states.dart';
import 'package:travel_app/features/user/home/presentation/widgets/trip_details_features_grid.dart';
import 'package:travel_app/features/user/home/presentation/widgets/trip_details_header_info.dart';
import 'package:travel_app/features/user/home/presentation/widgets/trip_details_image_carousel.dart';
import 'package:travel_app/features/user/home/presentation/widgets/trip_details_sections.dart';
import 'package:travel_app/features/user/home/presentation/widgets/trip_details_sticky_footer.dart';

class TripDetailsPage extends StatefulWidget {
  final AdminTripModel trip;

  const TripDetailsPage({super.key, required this.trip});

  @override
  State<TripDetailsPage> createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  int _selectedTabIndex = 0;
  late Set<int> _expandedDays;

  late final List<String> _tabs = [
    AppStrings.tripDetailsOverview,
    AppStrings.tripDetailsItinerary,
    AppStrings.tripDetailsIncluded,
    AppStrings.tripDetailsExcluded,
    AppStrings.tripDetailsGallery,
    AppStrings.tripDetailsReviews,
  ];

  AdminTripModel get trip => widget.trip;

  @override
  void initState() {
    super.initState();
    _expandedDays = trip.days.isEmpty ? <int>{} : {0};
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 200 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  List<String> get _heroImages {
    final images = <String>[];
    final cover = trip.coverImage?.trim() ?? '';
    if (cover.isNotEmpty) images.add(cover);
    for (final item in trip.gallery) {
      final path = item.trim();
      if (path.isNotEmpty && !images.contains(path)) images.add(path);
    }
    return images;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesCubit, FavoritesStates>(
      listenWhen: (_, current) =>
          current is FavoritesToggleSuccess ||
          current is FavoritesToggleFailure,
      listener: (context, state) {
        if (state is FavoritesToggleSuccess) {
          AppSnackbar.showSuccess(
            context: context,
            message: state.message,
            actionLabel: state.isFavorite ? AppStrings.viewAll : null,
            onAction: state.isFavorite
                ? () => context.push(RouteNames.favorites)
                : null,
          );
        } else if (state is FavoritesToggleFailure) {
          AppSnackbar.showError(context: context, message: state.message);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: TripDetailsStickyFooter(trip: trip),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    final images = _heroImages;
    final expandedHeight = 350.h;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: _isScrolled
                ? Colors.transparent
                : Colors.black.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back,
            color: _isScrolled ? AppColors.textPrimary : Colors.white,
          ),
        ),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: _isScrolled
                  ? Colors.transparent
                  : Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.share_outlined,
              color: _isScrolled ? AppColors.textPrimary : Colors.white,
            ),
          ),
          onPressed: () {},
        ),
        BlocBuilder<FavoritesCubit, FavoritesStates>(
          builder: (context, state) {
            final cubit = context.read<FavoritesCubit>();
            final tripId = trip.id?.trim() ?? '';
            final isFavorite = cubit.isFavorite(
              tripId,
              fallback: trip.isFavorite,
            );
            final isToggling = cubit.isToggling(tripId);

            return IconButton(
              icon: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: _isScrolled
                      ? Colors.transparent
                      : Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: isToggling
                    ? SizedBox(
                        width: 18.r,
                        height: 18.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: _isScrolled
                              ? AppColors.error
                              : Colors.white,
                        ),
                      )
                    : Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isScrolled
                            ? (isFavorite
                                  ? AppColors.error
                                  : AppColors.textPrimary)
                            : (isFavorite ? AppColors.error : Colors.white),
                      ),
              ),
              onPressed: tripId.isEmpty || isToggling
                  ? null
                  : () => cubit.toggleFavoriteTrip(trip),
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: TripDetailsImageCarousel(
          images: images,
          height: expandedHeight,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.r32)),
      ),
      transform: Matrix4.translationValues(0.0, -32.h, 0.0),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p24,
          vertical: AppSizes.p32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TripDetailsHeaderInfo(trip: trip),
            AppSizes.p24.verticalSpace,
            TripDetailsFeaturesGrid(trip: trip),
            AppSizes.p32.verticalSpace,
            _buildTabs(),
            AppSizes.p24.verticalSpace,
            _buildSelectedTabContent(),
            60.h.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTabIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = index),
            child: Container(
              margin: EdgeInsetsDirectional.only(end: AppSizes.p24),
              padding: EdgeInsets.only(bottom: AppSizes.p12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected
                        ? AppColors.primaryDark
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                _tabs[index],
                style: AppTextStyles.labelLarge.copyWith(
                  color: isSelected
                      ? AppColors.primaryDark
                      : AppColors.textHint,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSelectedTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOverview();
      case 1:
        return TripDetailsItinerary(
          days: trip.days,
          expandedDayIndexes: _expandedDays,
          onToggleDay: (index) {
            setState(() {
              if (_expandedDays.contains(index)) {
                _expandedDays.remove(index);
              } else {
                _expandedDays.add(index);
              }
            });
          },
        );
      case 2:
        return TripDetailsBulletList(items: trip.included);
      case 3:
        return TripDetailsBulletList(
          items: trip.excluded,
          bulletColor: AppColors.error,
        );
      case 4:
        return TripDetailsGalleryGrid(images: _heroImages);
      case 5:
        return _buildReviews();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          trip.description?.isNotEmpty == true ? trip.description! : '—',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        if (trip.cancelPolicy?.isNotEmpty == true) ...[
          AppSizes.p24.verticalSpace,
          Text(
            AppStrings.tripDetailsCancelPolicy,
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSizes.p8.verticalSpace,
          Text(
            trip.cancelPolicy!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildReviews() {
    if (trip.reviewsCount <= 0 && trip.averageRating <= 0) {
      return Text(
        AppStrings.tripDetailsNoReviews,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(Icons.star_rounded, color: AppColors.secondary, size: 28.sp),
          AppSizes.p12.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trip.averageRating.toStringAsFixed(1),
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark,
                ),
              ),
              Text(
                '${trip.reviewsCount} ${AppStrings.tripDetailsReviews}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
