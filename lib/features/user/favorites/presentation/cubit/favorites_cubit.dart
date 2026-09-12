import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';
import 'package:travel_app/features/user/favorites/data/repo/favorites_repo.dart';
import 'package:travel_app/features/user/favorites/presentation/cubit/favorites_states.dart';

class FavoritesCubit extends Cubit<FavoritesStates> {
  FavoritesCubit({required FavoritesRepo favoritesRepo})
    : _favoritesRepo = favoritesRepo,
      super(const FavoritesInitial());

  final FavoritesRepo _favoritesRepo;

  List<AdminTripModel> _favorites = [];
  final Set<String> _unfavoritedIds = {};
  int _currentPage = 1;
  final int _pageSize = 5;
  int _totalItems = 0;
  int _totalPages = 0;
  bool _hasMore = false;

  bool isFavorite(String tripId, {bool fallback = false}) {
    if (tripId.isEmpty) return fallback;
    if (_favorites.any((trip) => trip.id == tripId)) return true;
    if (_unfavoritedIds.contains(tripId)) return false;
    return fallback;
  }

  bool isToggling(String tripId) {
    final current = state;
    if (current is! FavoritesLoaded) return false;
    return current.togglingTripIds.contains(tripId);
  }

  Future<void> getFavorites() async {
    _currentPage = 1;
    emit(const FavoritesLoading());

    final result = await _favoritesRepo.getFavorites(_currentPage, _pageSize);
    result.fold(
      (failure) => emit(FavoritesError(message: failure.message)),
      (data) {
        final uniqueMap = <String, AdminTripModel>{};
        for (final trip in data.favorites) {
          final id = trip.id;
          if (id == null || id.isEmpty) continue;
          uniqueMap[id] = trip.copyWith(isFavorite: true);
        }

        _favorites = uniqueMap.values.toList();
        _totalItems = data.totalItems;
        _totalPages = data.totalPages;
        _currentPage = data.currentPage == 0 ? 1 : data.currentPage;
        _hasMore = data.totalPages > 0 && _currentPage < data.totalPages;
        for (final id in uniqueMap.keys) {
          _unfavoritedIds.remove(id);
        }

        emit(_loaded());
      },
    );
  }

  Future<void> loadMoreFavorites() async {
    final current = state;
    if (current is! FavoritesLoaded) return;
    if (!current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));

    final nextPage = _currentPage + 1;
    final result = await _favoritesRepo.getFavorites(nextPage, _pageSize);

    result.fold(
      (failure) => emit(current.copyWith(isLoadingMore: false)),
      (data) {
        final uniqueMap = <String, AdminTripModel>{
          for (final trip in _favorites)
            if (trip.id != null && trip.id!.isNotEmpty) trip.id!: trip,
        };

        for (final trip in data.favorites) {
          final id = trip.id;
          if (id == null || id.isEmpty) continue;
          uniqueMap[id] = trip.copyWith(isFavorite: true);
          _unfavoritedIds.remove(id);
        }

        _favorites = uniqueMap.values.toList();
        _totalItems = data.totalItems;
        _totalPages = data.totalPages;
        _currentPage = data.currentPage == 0 ? nextPage : data.currentPage;
        _hasMore = data.totalPages > 0 && _currentPage < data.totalPages;

        emit(_loaded(isLoadingMore: false));
      },
    );
  }

  /// Same idea as rahala: list presence = favorite.
  /// Uses backend `isFavorite` to add/remove from the list.
  Future<bool> toggleFavoriteTrip(AdminTripModel trip) async {
    final tripId = trip.id?.trim() ?? '';
    if (tripId.isEmpty) return false;

    final currentTrips = List<AdminTripModel>.from(_favorites);
    final toggling = {
      if (state is FavoritesLoaded) ...(state as FavoritesLoaded).togglingTripIds,
      tripId,
    };
    emit(_loaded(togglingTripIds: toggling));

    final result = await _favoritesRepo.toggleFavorite(tripId: tripId);
    return result.fold(
      (failure) {
        emit(_loaded(togglingTripIds: {...toggling}..remove(tripId)));
        return false;
      },
      (toggle) {
        final updated = List<AdminTripModel>.from(currentTrips);
        final existingIndex = updated.indexWhere((e) => e.id == tripId);

        if (toggle.isFavorite) {
          _unfavoritedIds.remove(tripId);
          if (existingIndex == -1) {
            updated.add(trip.copyWith(isFavorite: true));
            _totalItems += 1;
          } else {
            updated[existingIndex] = updated[existingIndex].copyWith(
              isFavorite: true,
            );
          }
        } else {
          _unfavoritedIds.add(tripId);
          if (existingIndex != -1) {
            updated.removeAt(existingIndex);
            if (_totalItems > 0) _totalItems -= 1;
          }
        }

        _favorites = updated;
        emit(
          _loaded(
            togglingTripIds: {...toggling}..remove(tripId),
          ),
        );
        return true;
      },
    );
  }

  FavoritesLoaded _loaded({
    Set<String>? togglingTripIds,
    bool isLoadingMore = false,
  }) {
    return FavoritesLoaded(
      favorites: List<AdminTripModel>.from(_favorites),
      togglingTripIds: togglingTripIds ?? const {},
      totalItems: _totalItems,
      totalPages: _totalPages,
      currentPage: _currentPage,
      pageSize: _pageSize,
      hasMore: _hasMore,
      isLoadingMore: isLoadingMore,
    );
  }
}
