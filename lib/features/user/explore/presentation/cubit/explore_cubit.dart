import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';
import 'package:travel_app/features/user/explore/data/repo/explore_repo.dart';
import 'package:travel_app/features/user/explore/presentation/cubit/explore_states.dart';

class ExploreCubit extends Cubit<ExploreStates> {
  ExploreCubit({required ExploreRepo exploreRepo})
    : _exploreRepo = exploreRepo,
      super(const ExploreInitial());

  final ExploreRepo _exploreRepo;

  int _page = 1;
  int _total = 0;
  int _limit = 5;
  String _category = '';
  int _currentIndex = 0;
  bool _hasMore = false;
  List<AdminTripModel> _trips = [];
  AdminTripsData _tripsData = AdminTripsData();
  final Map<int, AdminTripsData> _tripsFiltered = {};

  Future<void> getTripsFiltered(
    String category, {
    required int index,
    bool forceRefresh = false,
  }) async {
    if (category.isEmpty) return;

    _page = 1;
    _category = category;
    _currentIndex = index;

    // Use cached trips for this category index when available.
    if (!forceRefresh && _tripsFiltered.containsKey(index)) {
      final cachedData = _tripsFiltered[index]!;
      _tripsData = cachedData;
      _trips = List<AdminTripModel>.from(cachedData.trips);
      _page = cachedData.currentPage;
      _total = cachedData.totalItems;
      _limit = cachedData.pageSize;
      _hasMore = _page < cachedData.totalPages;
      _emitLoaded();
      return;
    }

    emit(const ExploreLoading());

    final result = await _exploreRepo.getTripsFiltered(
      category,
      page: _page,
      limit: _limit,
    );

    result.fold((failure) => emit(ExploreError(message: failure.message)), (
      tripsData,
    ) {
      _tripsData = tripsData;
      _trips = tripsData.trips;
      _total = tripsData.totalItems;
      _page = tripsData.currentPage == 0 ? 1 : tripsData.currentPage;
      _limit = tripsData.pageSize == 0 ? _limit : tripsData.pageSize;
      _hasMore = _page < tripsData.totalPages;
      _tripsFiltered[index] = AdminTripsData(
        trips: List<AdminTripModel>.from(tripsData.trips),
        currentPage: _page,
        totalItems: _total,
        totalPages: tripsData.totalPages,
        pageSize: _limit,
      );
      _emitLoaded();
    });
  }

  Future<void> loadMoreTrips() async {
    final currentState = state;
    if (currentState is! ExploreLoaded) return;
    if (!currentState.hasMore || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = _page + 1;
    final result = await _exploreRepo.getTripsFiltered(
      _category,
      page: nextPage,
      limit: _limit,
    );

    result.fold(
      (failure) {
        emit(currentState.copyWith(isLoadingMore: false));
      },
      (tripsData) {
        _tripsData = tripsData;
        _trips = List<AdminTripModel>.from(_trips)..addAll(tripsData.trips);
        _total = tripsData.totalItems;
        _page = tripsData.currentPage == 0 ? nextPage : tripsData.currentPage;
        _limit = tripsData.pageSize == 0 ? _limit : tripsData.pageSize;
        _hasMore = _page < tripsData.totalPages;
        _tripsFiltered[_currentIndex] = AdminTripsData(
          trips: List<AdminTripModel>.from(_trips),
          currentPage: _page,
          totalItems: _total,
          totalPages: tripsData.totalPages,
          pageSize: _limit,
        );
        _emitLoaded();
      },
    );
  }

  void _emitLoaded() {
    emit(
      ExploreLoaded(
        tripsData: _tripsData,
        trips: _trips,
        hasMore: _hasMore,
        page: _page,
        limit: _limit,
        total: _total,
        category: _category,
      ),
    );
  }
}
