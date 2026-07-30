import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/features/admin/trips/data/repo/admin_trips_repo.dart';
import 'package:travel_app/features/admin/trips/presentation/cubit/admin_trips_states.dart';

class AdminTripsCubit extends Cubit<AdminTripsStates> {
  AdminTripsCubit({required AdminTripsRepo adminTripsRepo})
    : _adminTripsRepo = adminTripsRepo,
      super(const AdminTripsInitial());

  final AdminTripsRepo _adminTripsRepo;

  String? _selectedStatus;

  Future<void> getAdminTrips({String? status}) async {
    _selectedStatus = status;
    emit(const AdminTripsLoading());

    final result = await _adminTripsRepo.getAdminTrips(
      page: 1,
      limit: 10,
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

  void updateStatus(String? status) {
    if (_selectedStatus == status && state is AdminTripsSuccess) return;
    getAdminTrips(status: status);
  }
}
