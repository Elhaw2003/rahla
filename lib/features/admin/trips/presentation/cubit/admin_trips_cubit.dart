import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';
import 'package:travel_app/features/admin/trips/data/repo/admin_trips_repo.dart';
import 'package:travel_app/features/admin/trips/presentation/cubit/admin_trips_states.dart';

class AdminTripsCubit extends Cubit<AdminTripsStates> {
  AdminTripsCubit({required this._adminTripsRepo})
    : super(const AdminTripsInitial());

  final AdminTripsRepo _adminTripsRepo;

  String? _selectedStatus;
  final int _currentPage = 1;
  final int _limit = 10;

  Future<void> getAdminTrips({String? status}) async {
    _selectedStatus = status;
    emit(const AdminTripsLoading());

    final result = await _adminTripsRepo.getAdminTrips(
      page: _currentPage,
      limit: _limit,
      status: status,
    );

    result.fold(
      (failure) => emit(AdminTripsFailure(message: failure.message)),
      (response) {
        final data = response.data;
        final currentPage = data?.currentPage ?? 1;
        final totalPages = data?.totalPages ?? 0;

        emit(
          AdminTripsSuccess(
            adminTrips: data?.trips ?? const [],
            totalItems: data?.totalItems ?? 0,
            status: _selectedStatus,
            totalPages: totalPages,
            currentPage: currentPage,
            hasMore: currentPage < totalPages,
          ),
        );
      },
    );
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! AdminTripsSuccess) return;
    if (!currentState.hasMore || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;
    final result = await _adminTripsRepo.getAdminTrips(
      status: _selectedStatus,
      page: nextPage,
      limit: _limit,
    );

    result.fold(
      (failure) => emit(currentState.copyWith(isLoadingMore: false)),
      (response) {
        final data = response.data;
        final updatedTrips = List<AdminTripModel>.from(currentState.adminTrips)
          ..addAll(data?.trips ?? const []);
        final currentPage = data?.currentPage ?? nextPage;
        final totalPages = data?.totalPages ?? currentState.totalPages;

        emit(
          AdminTripsSuccess(
            adminTrips: updatedTrips,
            totalItems: data?.totalItems ?? currentState.totalItems,
            status: _selectedStatus,
            totalPages: totalPages,
            currentPage: currentPage,
            hasMore: currentPage < totalPages,
          ),
        );
      },
    );
  }

  void updateStatus(String? status) {
    if (_selectedStatus == status && state is AdminTripsSuccess) return;
    getAdminTrips(status: status);
  }
}
