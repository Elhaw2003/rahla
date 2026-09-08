import 'package:flutter/material.dart';
import 'package:travel_app/core/constants/app_strings.dart';
import 'package:travel_app/features/admin/bookings/presentation/cubit/admin_booking_states.dart';
import 'package:travel_app/features/admin/bookings/presentation/widgets/admin_bookings_list.dart';
import 'package:travel_app/features/admin/bookings/presentation/widgets/admin_bookings_status_filters.dart';
import 'package:travel_app/features/admin/bookings/presentation/widgets/admin_bookings_trip_filter.dart';

class AdminBookingsBody extends StatelessWidget {
  final AdminBookingSuccess state;
  final String approveLoadingId;
  final String rejectLoadingId;
  final ScrollController scrollController;

  const AdminBookingsBody({
    super.key,
    required this.state,
    required this.approveLoadingId,
    required this.rejectLoadingId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final tripOptions = [
      AppStrings.adminFilterAllTrips,
      ...state.data.bookings.map((booking) => booking.trip.title).toSet(),
    ];
    final selectedTrip = tripOptions.contains(state.filterTrip)
        ? state.filterTrip
        : AppStrings.adminFilterAllTrips;

    return Column(
      children: [
        AdminBookingsStatusFilters(
          selectedStatus: state.status,
          allCount: state.total,
          pendingCount: state.pendingBookingsCount,
          approvedCount: state.approvedBookingsCount,
          rejectedCount: state.rejectedBookingsCount,
        ),
        AdminBookingsTripFilter(
          tripOptions: tripOptions,
          selectedTrip: selectedTrip,
        ),
        AdminBookingsList(
          bookings: state.filteredBookings,
          isLoadingMore: state.isLoading,
          approveLoadingId: approveLoadingId,
          rejectLoadingId: rejectLoadingId,
          scrollController: scrollController,
        ),
      ],
    );
  }
}
