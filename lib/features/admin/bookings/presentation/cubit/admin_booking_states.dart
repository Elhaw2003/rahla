import 'package:equatable/equatable.dart';
import 'package:travel_app/features/admin/bookings/data/models/admin_booking_model.dart';

abstract class AdminBookingStates extends Equatable {
  const AdminBookingStates();
  @override
  List<Object> get props => [];
}

class AdminBookingInitial extends AdminBookingStates {
  const AdminBookingInitial();
  @override
  List<Object> get props => [];
}

class AdminBookingLoading extends AdminBookingStates {
  const AdminBookingLoading();
  @override
  List<Object> get props => [];
}

class AdminBookingSuccess extends AdminBookingStates {
  final AdminBookingDataModel data;
  final int total;
  final int limit;
  final int page;
  final bool isLoading;
  final bool hasMore;
  final List<AdminBookingModel> filteredBookings;
  final String filterTrip;
  final int pendingBookingsCount;
  final int approvedBookingsCount;
  final int rejectedBookingsCount;
  final String status;
  final String processingBookingId;
  final String processingAction;
  const AdminBookingSuccess({
    required this.data,
    required this.total,
    required this.limit,
    required this.page,
    this.isLoading = false,
    required this.hasMore,
    required this.filteredBookings,
    this.filterTrip = 'جميع الرحلات',
    required this.pendingBookingsCount,
    required this.approvedBookingsCount,
    required this.rejectedBookingsCount,
    this.status = 'all',
    this.processingBookingId = '',
    this.processingAction = '',
  });
  AdminBookingSuccess copyWith({
    AdminBookingDataModel? data,
    int? total,
    int? limit,
    int? page,
    bool? isLoading,
    bool? hasMore,
    List<AdminBookingModel>? filteredBookings,
    String? filterTrip,
    int? pendingBookingsCount,
    int? approvedBookingsCount,
    int? rejectedBookingsCount,
    String? status,
    String? processingBookingId,
    String? processingAction,
  }) => AdminBookingSuccess(
    data: data ?? this.data,
    total: total ?? this.total,
    limit: limit ?? this.limit,
    page: page ?? this.page,
    isLoading: isLoading ?? this.isLoading,
    hasMore: hasMore ?? this.hasMore,
    filteredBookings: filteredBookings ?? this.filteredBookings,
    filterTrip: filterTrip ?? this.filterTrip,
    pendingBookingsCount: pendingBookingsCount ?? this.pendingBookingsCount,
    approvedBookingsCount: approvedBookingsCount ?? this.approvedBookingsCount,
    rejectedBookingsCount: rejectedBookingsCount ?? this.rejectedBookingsCount,
    status: status ?? this.status,
    processingBookingId: processingBookingId ?? this.processingBookingId,
    processingAction: processingAction ?? this.processingAction,
  );

  @override
  List<Object> get props => [
    data,
    total,
    limit,
    page,
    isLoading,
    hasMore,
    filteredBookings,
    filterTrip,
    pendingBookingsCount,
    approvedBookingsCount,
    rejectedBookingsCount,
    status,
    processingBookingId,
    processingAction,
  ];
}

class AdminBookingError extends AdminBookingStates {
  final String error;
  const AdminBookingError({required this.error});
  @override
  List<Object> get props => [error];
}

class AdminBookingApproveLoading extends AdminBookingStates {
  final String bookingId;
  const AdminBookingApproveLoading({required this.bookingId});
  @override
  List<Object> get props => [bookingId];
}

class AdminBookingApproveSuccess extends AdminBookingStates {
  final AdminBookingModel booking;
  const AdminBookingApproveSuccess({required this.booking});
  @override
  List<Object> get props => [booking];
}

class AdminBookingApproveError extends AdminBookingStates {
  final String error;
  const AdminBookingApproveError({required this.error});
  @override
  List<Object> get props => [error];
}

class AdminBookingRejectLoading extends AdminBookingStates {
  final String bookingId;
  const AdminBookingRejectLoading({required this.bookingId});
  @override
  List<Object> get props => [bookingId];
}

class AdminBookingRejectSuccess extends AdminBookingStates {
  final AdminBookingModel booking;
  const AdminBookingRejectSuccess({required this.booking});
  @override
  List<Object> get props => [booking];
}

class AdminBookingRejectError extends AdminBookingStates {
  final String error;
  const AdminBookingRejectError({required this.error});
  @override
  List<Object> get props => [error];
}
