import 'package:equatable/equatable.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';

abstract class ExploreStates extends Equatable {
  const ExploreStates();

  @override
  List<Object?> get props => [];
}

class ExploreInitial extends ExploreStates {
  const ExploreInitial();
  @override
  List<Object?> get props => [];
}

class ExploreLoading extends ExploreStates {
  const ExploreLoading();
  @override
  List<Object?> get props => [];
}

class ExploreLoaded extends ExploreStates {
  final AdminTripsData tripsData;
  final List<AdminTripModel> trips;
  final bool isLoadingMore;
  final bool hasMore;
  final int page;
  final int limit;
  final int total;
  final String category;
  const ExploreLoaded({
    required this.tripsData,
    required this.trips,
    required this.hasMore,
    required this.page,
    required this.limit,
    required this.category,
    required this.total,
    this.isLoadingMore = false,
  });
  ExploreLoaded copyWith({
    AdminTripsData? tripsData,
    List<AdminTripModel>? trips,
    bool? hasMore,
    int? page,
    int? limit,
    int? total,
    String? category,
    bool? isLoadingMore,
  }) => ExploreLoaded(
    tripsData: tripsData ?? this.tripsData,
    trips: trips ?? this.trips,
    hasMore: hasMore ?? this.hasMore,
    page: page ?? this.page,
    limit: limit ?? this.limit,
    total: total ?? this.total,
    category: category ?? this.category,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );
  @override
  List<Object?> get props => [
    tripsData,
    trips,
    hasMore,
    page,
    limit,
    total,
    category,
    isLoadingMore,
  ];
}

class ExploreError extends ExploreStates {
  final String message;
  const ExploreError({required this.message});
  @override
  List<Object?> get props => [message];
}
