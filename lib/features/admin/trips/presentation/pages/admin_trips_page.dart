import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/core/constants/app_colors.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/core/router/route_names.dart';
import 'package:travel_app/core/shared/widgets/app_button.dart';
import 'package:travel_app/core/shared/widgets/app_loading.dart';
import 'package:travel_app/core/shared/widgets/app_snackbar.dart';
import 'package:travel_app/core/theme/app_sizes.dart';
import 'package:travel_app/core/theme/app_text_styles.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';
import 'package:travel_app/features/admin/trips/presentation/cubit/admin_trips_cubit.dart';
import 'package:travel_app/features/admin/trips/presentation/cubit/admin_trips_states.dart';
import 'package:travel_app/features/admin/trips/presentation/widgets/admin_trip_card.dart';

class AdminTripsPage extends StatefulWidget {
  const AdminTripsPage({super.key});

  @override
  State<AdminTripsPage> createState() => _AdminTripsPageState();
}

class _AdminTripsPageState extends State<AdminTripsPage> {
  int _selectedFilterIndex = 0;

  static const _filterStatuses = <String?>[
    null,
    'published',
    'unpublished',
    'draft',
  ];

  String _formatPrice(num price) {
    return '${NumberFormat('#,###').format(price)} ${AppStrings.currencyEGP}';
  }

  String _formatDuration(AdminTripModel trip) {
    final start = DateTime.tryParse(trip.startDate ?? '');
    final end = DateTime.tryParse(trip.endDate ?? '');
    if (start == null || end == null) return trip.destination ?? '';

    final days = end.difference(start).inDays;
    if (days <= 0) return trip.destination ?? '';
    final nights = days > 0 ? days - 1 : 0;
    return '$days أيام / $nights ليلة';
  }

  String _statusLabel(String? status) {
    switch (status) {
      case 'published':
        return AppStrings.adminFilterPublished;
      case 'unpublished':
        return AppStrings.adminFilterUnpublished;
      case 'draft':
        return AppStrings.adminFilterDraft;
      case 'cancelled':
        return 'ملغاة';
      default:
        return status ?? '';
    }
  }

  String _imageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return 'https://rahala.duckdns.org$path';
  }

  void _onFilterTap(int index) {
    setState(() => _selectedFilterIndex = index);
    context.read<AdminTripsCubit>().updateStatus(_filterStatuses[index]);
  }

  @override
  Widget build(BuildContext context) {
    final filterLabels = [
      AppStrings.bookingsFilterAll,
      AppStrings.adminFilterPublished,
      AppStrings.adminFilterUnpublished,
      AppStrings.adminFilterDraft,
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppStrings.adminTripsTitle,
          style: AppTextStyles.titleLarge,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
                child: Row(
                  children: List.generate(
                    filterLabels.length,
                    (index) => _buildFilterTab(
                      label: filterLabels[index],
                      isSelected: _selectedFilterIndex == index,
                      onTap: () => _onFilterTap(index),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocConsumer<AdminTripsCubit, AdminTripsStates>(
                listener: (context, state) {
                  if (state is AdminTripsFailure) {
                    AppSnackbar.showError(
                      context: context,
                      message: state.message,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AdminTripsLoading ||
                      state is AdminTripsInitial) {
                    return const AppLoading();
                  }

                  if (state is AdminTripsFailure) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSizes.p24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.message,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: AppSizes.p16),
                            AppButton(
                              text: 'إعادة المحاولة',
                              onPressed: () => context
                                  .read<AdminTripsCubit>()
                                  .getAdminTrips(
                                    status: _filterStatuses[_selectedFilterIndex],
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is AdminTripsSuccess) {
                    final trips = state.adminTrips;

                    if (trips.isEmpty) {
                      return Center(
                        child: Text(
                          AppStrings.favoritesEmpty,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => context
                          .read<AdminTripsCubit>()
                          .getAdminTrips(
                            status: _filterStatuses[_selectedFilterIndex],
                          ),
                      child: ListView.separated(
                        padding: EdgeInsets.all(AppSizes.p20),
                        itemCount: trips.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: AppSizes.p16),
                        itemBuilder: (context, index) {
                          final trip = trips[index];
                          return AdminTripCard(
                            title: trip.title ?? '',
                            duration: _formatDuration(trip),
                            price: _formatPrice(trip.price),
                            status: _statusLabel(trip.status),
                            imagePath: _imageUrl(trip.coverImage),
                            onEdit: () {},
                            onDelete: () {},
                            onRepublish: () {},
                            onView: () {
                              context.push(
                                RouteNames.adminBookings,
                                extra: trip.title,
                              );
                            },
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: AppStrings.adminAddTrip,
        backgroundColor: AppColors.primary,
        onPressed: () async {
          final created = await context.push<bool>(RouteNames.addTrip);
          if (created == true && context.mounted) {
            context.read<AdminTripsCubit>().getAdminTrips();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.p16,
          vertical: AppSizes.p12,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.titleSmall.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
