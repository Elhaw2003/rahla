import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';
import 'package:travel_app/features/user/home/data/models/offer_model.dart';
import 'package:travel_app/features/user/home/data/repo/home_repo.dart';
import 'package:travel_app/features/user/home/presentation/cubit/home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit({required HomeRepo homeRepo})
    : _homeRepo = homeRepo,
      super(const HomeInitial());

  final HomeRepo _homeRepo;

  int _total = 0;
  int _page = 1;
  int _limit = 10;
  final String _sort = 'newest';
  bool _hasMore = false;
  List<AdminTripModel> _trips = [];
  List<OfferModel> _offers = [];

  Future<void> loadHome() async {
    emit(const HomeLoading());
    await Future.wait([
      getTrips(showLoading: false),
      getOffers(),
    ]);
  }

  Future<void> getTrips({bool showLoading = true}) async {
    _page = 1;
    if (showLoading) emit(const HomeLoading());

    final result = await _homeRepo.getTrips(
      page: _page,
      limit: _limit,
      sort: _sort,
    );

    result.fold(
      (failure) {
        emit(HomeError(message: failure.message));
      },
      (tripsData) {
        _trips = tripsData.trips;
        _total = tripsData.totalItems;
        _page = tripsData.currentPage == 0 ? 1 : tripsData.currentPage;
        _limit = tripsData.pageSize == 0 ? _limit : tripsData.pageSize;
        _hasMore = _page < tripsData.totalPages;
        _emitSuccess();
      },
    );
  }

  Future<void> fetchMoreTrips() async {
    final currentState = state;
    if (currentState is! HomeSuccess) return;
    if (!currentState.hasMore || currentState.isLoading) return;

    emit(currentState.copyWith(isLoading: true));

    final nextPage = _page + 1;
    final result = await _homeRepo.getTrips(
      page: nextPage,
      limit: _limit,
      sort: _sort,
    );

    result.fold(
      (failure) {
        emit(currentState.copyWith(isLoading: false));
      },
      (tripsData) {
        _trips = List<AdminTripModel>.from(_trips)..addAll(tripsData.trips);
        _total = tripsData.totalItems;
        _page = tripsData.currentPage == 0 ? nextPage : tripsData.currentPage;
        _limit = tripsData.pageSize == 0 ? _limit : tripsData.pageSize;
        _hasMore = _page < tripsData.totalPages;
        _emitSuccess();
      },
    );
  }

  Future<void> getOffers() async {
    final result = await _homeRepo.getOffers();

    result.fold(
      (failure) {
        if (state is! HomeSuccess) {
          emit(HomeError(message: failure.message));
        }
      },
      (offers) {
        _offers = offers;
        _emitSuccess();
      },
    );
  }

  void _emitSuccess() {
    emit(
      HomeSuccess(
        trips: _trips,
        offers: _offers,
        page: _page,
        limit: _limit,
        total: _total,
        hasMore: _hasMore,
        sort: _sort,
      ),
    );
  }
}
