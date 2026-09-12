import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';
import 'package:travel_app/features/user/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:travel_app/features/user/favorites/presentation/cubit/favorites_states.dart';

class TripFavoriteButton extends StatelessWidget {
  final AdminTripModel trip;
  final double iconSize;
  final Color? activeColor;
  final Color? inactiveColor;
  final EdgeInsetsGeometry? padding;
  final bool showBackground;

  const TripFavoriteButton({
    super.key,
    required this.trip,
    this.iconSize = 16,
    this.activeColor,
    this.inactiveColor,
    this.padding,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final tripId = trip.id?.trim() ?? '';
    if (tripId.isEmpty) return const SizedBox.shrink();

    return BlocBuilder<FavoritesCubit, FavoritesStates>(
      builder: (context, state) {
        final cubit = context.read<FavoritesCubit>();
        final isFavorite = cubit.isFavorite(
          tripId,
          fallback: trip.isFavorite,
        );
        final isToggling = cubit.isToggling(tripId);

        final icon = isToggling
            ? SizedBox(
                width: iconSize.sp,
                height: iconSize.sp,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: activeColor ?? AppColors.error,
                ),
              )
            : Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                size: iconSize.sp,
                color: isFavorite
                    ? (activeColor ?? AppColors.error)
                    : (inactiveColor ?? AppColors.textSecondary),
              );

        final child = showBackground
            ? Container(
                padding: padding ?? EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.95),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: icon,
              )
            : Padding(
                padding: padding ?? EdgeInsets.zero,
                child: icon,
              );

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isToggling
              ? null
              : () => cubit.toggleFavoriteTrip(trip),
          child: child,
        );
      },
    );
  }
}
