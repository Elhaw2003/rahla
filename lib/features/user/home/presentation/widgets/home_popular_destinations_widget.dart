import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_app/core/constants/app_assets.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/extensions/widget_extension.dart';
import 'package:travel_app/core/router/route_names.dart';
import 'package:travel_app/core/shared/widgets/app_loading.dart';
import 'package:travel_app/core/shared/widgets/app_network_image.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';

class HomePopularDestinationsWidget extends StatefulWidget {
  final List<AdminTripModel> trips;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;

  const HomePopularDestinationsWidget({
    super.key,
    this.trips = const [],
    this.hasMore = false,
    this.isLoadingMore = false,
    this.onLoadMore,
  });

  @override
  State<HomePopularDestinationsWidget> createState() =>
      _HomePopularDestinationsWidgetState();
}

class _HomePopularDestinationsWidgetState
    extends State<HomePopularDestinationsWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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
        _scrollController.position.maxScrollExtent - 200) {
      widget.onLoadMore?.call();
    }
  }

  String _imageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return 'https://rahala.duckdns.org$path';
  }

  String _formatPrice(num price) {
    return NumberFormat('#,###').format(price);
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.trips.length + (widget.isLoadingMore ? 1 : 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.homePopularDestinations,
              style: AppTextStyles.titleMedium,
            ),
            Text(
              AppStrings.viewAll,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
            ),
          ],
        ).paddingSymmetric(horizontal: AppSizes.p16),
        AppSizes.p12.verticalSpace,
        SizedBox(
          height: 160.h,
          child: widget.trips.isEmpty
              ? Center(
                  child: Text(
                    AppStrings.favoritesEmpty,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
              : ListView.separated(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
                  scrollDirection: Axis.horizontal,
                  itemCount: itemCount,
                  separatorBuilder: (_, _) => AppSizes.p12.horizontalSpace,
                  itemBuilder: (context, index) {
                    if (index >= widget.trips.length) {
                      return SizedBox(
                        width: 48.w,
                        child: const AppLoading(size: 24),
                      );
                    }

                    final trip = widget.trips[index];
                    return DestinationCard(
                      imageUrl: _imageUrl(trip.coverImage),
                      title: trip.destination?.isNotEmpty == true
                          ? trip.destination!
                          : (trip.title ?? ''),
                      price: _formatPrice(trip.price),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class DestinationCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;

  const DestinationCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(RouteNames.tripDetails),
      child: Container(
        width: 120.w,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.r16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppSizes.r16),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 90.h,
                child: imageUrl.isNotEmpty
                    ? AppNetworkImage(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        height: 90.h,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(AppAssets.homeFeatured, fit: BoxFit.cover),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSizes.p4.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$price ${AppStrings.currencyEGP}',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.favorite_border,
                      size: 14.sp,
                      color: AppColors.textHint,
                    ),
                  ],
                ),
              ],
            ).paddingAll(AppSizes.p12).expanded(),
          ],
        ),
      ),
    );
  }
}
