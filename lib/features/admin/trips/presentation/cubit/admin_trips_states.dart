import 'package:equatable/equatable.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';

abstract class AdminTripsStates extends Equatable {
  const AdminTripsStates();
  @override
  List<Object?> get props => [];
}

class AdminTripsInitial extends AdminTripsStates {
  const AdminTripsInitial();
  @override
  List<Object?> get props => [];
}

class AdminTripsLoading extends AdminTripsStates {
  const AdminTripsLoading();
  @override
  List<Object?> get props => [];
}

class AdminTripsSuccess extends AdminTripsStates {
  final List<AdminTripModel> adminTrips;
  final int totalItems;
  final String? status;
  final int totalPages;
  final int currentPage;
  final bool hasMore;
  final bool? isLoadingMore;
  const AdminTripsSuccess({
    required this.adminTrips,
    required this.totalItems,
    required this.status,
    required this.totalPages,
    required this.currentPage,
    required this.hasMore,
    this.isLoadingMore = false,
  });
  AdminTripsSuccess copyWith({
    List<AdminTripModel>? adminTrips,
    int? totalItems,
    String? status,
    int? totalPages,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return AdminTripsSuccess(
      adminTrips: adminTrips ?? this.adminTrips,
      totalItems: totalItems ?? this.totalItems,
      status: status ?? this.status,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    adminTrips,
    totalItems,
    status,
    totalPages,
    currentPage,
    hasMore,
    isLoadingMore,
  ];
}

class AdminTripsFailure extends AdminTripsStates {
  final String message;
  const AdminTripsFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
