import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/shared/widgets/app_loading.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';
import 'package:travel_app/features/user/favorites/presentation/widgets/favorite_card.dart';
import 'package:travel_app/features/user/favorites/presentation/widgets/favorites_empty_view.dart';

class FavoritesList extends StatelessWidget {
  final List<AdminTripModel> favorites;
  final bool isLoadingMore;
  final ScrollController? scrollController;

  const FavoritesList({
    super.key,
    required this.favorites,
    this.isLoadingMore = false,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) {
      return const FavoritesEmptyView();
    }

    final itemCount = favorites.length + (isLoadingMore ? 1 : 0);

    return ListView.separated(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        AppSizes.p16,
        0,
        AppSizes.p16,
        AppSizes.p24,
      ),
      itemCount: itemCount,
      separatorBuilder: (_, _) => AppSizes.p16.verticalSpace,
      itemBuilder: (context, index) {
        if (index >= favorites.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.p12),
            child: const AppLoading(size: 28),
          );
        }
        return FavoriteCard(trip: favorites[index]);
      },
    );
  }
}
