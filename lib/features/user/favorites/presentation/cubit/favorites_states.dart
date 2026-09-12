import 'package:equatable/equatable.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';

abstract class FavoritesStates extends Equatable {
  const FavoritesStates();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesStates {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesStates {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesStates {
  final List<AdminTripModel> favorites;
  final Set<String> togglingTripIds;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final bool hasMore;
  final bool isLoadingMore;

  const FavoritesLoaded({
    required this.favorites,
    this.togglingTripIds = const {},
    this.totalItems = 0,
    this.totalPages = 0,
    this.currentPage = 1,
    this.pageSize = 5,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  FavoritesLoaded copyWith({
    List<AdminTripModel>? favorites,
    Set<String>? togglingTripIds,
    int? totalItems,
    int? totalPages,
    int? currentPage,
    int? pageSize,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return FavoritesLoaded(
      favorites: favorites ?? this.favorites,
      togglingTripIds: togglingTripIds ?? this.togglingTripIds,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    favorites,
    togglingTripIds,
    totalItems,
    totalPages,
    currentPage,
    pageSize,
    hasMore,
    isLoadingMore,
  ];
}

class FavoritesError extends FavoritesStates {
  final String message;

  const FavoritesError({required this.message});

  @override
  List<Object?> get props => [message];
}
