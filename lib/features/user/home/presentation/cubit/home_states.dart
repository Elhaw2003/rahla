import 'package:equatable/equatable.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';
import 'package:travel_app/features/user/home/data/models/offer_model.dart';

abstract class HomeStates extends Equatable {
  const HomeStates();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeStates {
  const HomeInitial();
}

class HomeLoading extends HomeStates {
  const HomeLoading();
}

class HomeSuccess extends HomeStates {
  final List<AdminTripModel> trips;
  final List<OfferModel> offers;
  final int total;
  final int limit;
  final int page;
  final bool isLoading;
  final bool hasMore;
  final String sort;

  const HomeSuccess({
    required this.trips,
    required this.page,
    required this.limit,
    required this.total,
    required this.hasMore,
    required this.sort,
    this.offers = const [],
    this.isLoading = false,
  });

  HomeSuccess copyWith({
    List<AdminTripModel>? trips,
    List<OfferModel>? offers,
    int? page,
    int? limit,
    int? total,
    bool? hasMore,
    bool? isLoading,
    String? sort,
  }) => HomeSuccess(
    trips: trips ?? this.trips,
    offers: offers ?? this.offers,
    page: page ?? this.page,
    limit: limit ?? this.limit,
    total: total ?? this.total,
    hasMore: hasMore ?? this.hasMore,
    isLoading: isLoading ?? this.isLoading,
    sort: sort ?? this.sort,
  );

  @override
  List<Object?> get props => [
    trips,
    offers,
    page,
    limit,
    total,
    hasMore,
    isLoading,
    sort,
  ];
}

class HomeError extends HomeStates {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
