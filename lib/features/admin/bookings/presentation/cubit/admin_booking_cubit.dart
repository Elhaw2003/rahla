import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/features/admin/bookings/data/models/admin_booking_model.dart';
import 'package:travel_app/features/admin/bookings/data/repo/admin_booking_repo.dart';
import 'package:travel_app/features/admin/bookings/presentation/cubit/admin_booking_states.dart';

class AdminBookingCubit extends Cubit<AdminBookingStates> {
  AdminBookingCubit({required this.adminBookingRepo})
    : super(const AdminBookingInitial());
  final AdminBookingRepo adminBookingRepo;

  List<AdminBookingModel> _allBookings = [];
  AdminBookingDataModel? _data;
  String _selectedTrip = 'جميع الرحلات';
  String _currentStatus = 'all';
  int _total = 0;
  final int _limit = 3;
  int _page = 1;
  bool _hasMore = false;
  int _pendingBookingsCount = 0;
  int _approvedBookingsCount = 0;
  int _rejectedBookingsCount = 0;

  String? get _apiStatus => _currentStatus == 'all' ? null : _currentStatus;

  Future<void> getAdminBookings() async {
    _page = 1;
    emit(const AdminBookingLoading());

    final result = await adminBookingRepo.getAdminBookings(
      status: _apiStatus,
      page: _page,
      limit: _limit,
    );

    result.fold(
      (failure) {
        emit(AdminBookingError(error: failure.message));
      },
      (data) {
        _allBookings = data.bookings;
        _total = data.totalItems;
        _page = data.currentPage == 0 ? 1 : data.currentPage;
        _hasMore = data.totalPages > 0 && _page < data.totalPages;
        _updateCountsFromCurrentList();
        _data = AdminBookingDataModel(
          totalItems: data.totalItems,
          totalPages: data.totalPages,
          currentPage: _page,
          pageSize: data.pageSize,
          bookings: _allBookings,
        );
        _emitFilteredStates();
      },
    );
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! AdminBookingSuccess) return;
    if (!currentState.hasMore || currentState.isLoading) return;

    emit(currentState.copyWith(isLoading: true));

    final nextPage = _page + 1;
    final result = await adminBookingRepo.getAdminBookings(
      status: _apiStatus,
      page: nextPage,
      limit: _limit,
    );

    result.fold(
      (failure) {
        emit(currentState.copyWith(isLoading: false));
      },
      (data) {
        final updatedBookings = List<AdminBookingModel>.from(_allBookings)
          ..addAll(data.bookings);
        _allBookings = updatedBookings;
        _total = data.totalItems;
        _page = data.currentPage == 0 ? nextPage : data.currentPage;
        _hasMore = data.totalPages > 0 && _page < data.totalPages;
        _updateCountsFromCurrentList();
        _data = AdminBookingDataModel(
          totalItems: data.totalItems,
          totalPages: data.totalPages,
          currentPage: _page,
          pageSize: data.pageSize,
          bookings: _allBookings,
        );
        _emitFilteredStates();
      },
    );
  }

  void _updateCountsFromCurrentList() {
    if (_currentStatus != 'all') return;
    _pendingBookingsCount = _allBookings
        .where((booking) => booking.status == 'pending')
        .length;
    _approvedBookingsCount = _allBookings
        .where((booking) => booking.status == 'approved')
        .length;
    _rejectedBookingsCount = _allBookings
        .where((booking) => booking.status == 'rejected')
        .length;
  }

  void _emitFilteredStates() {
    final data = _data;
    if (data == null) return;

    emit(
      AdminBookingSuccess(
        data: data,
        total: _total,
        limit: _limit,
        page: _page,
        hasMore: _hasMore,
        filteredBookings: _allBookings.where(_matchFilters).toList(),
        filterTrip: _selectedTrip,
        pendingBookingsCount: _pendingBookingsCount,
        approvedBookingsCount: _approvedBookingsCount,
        rejectedBookingsCount: _rejectedBookingsCount,
        status: _currentStatus,
      ),
    );
  }

  bool _matchFilters(AdminBookingModel booking) {
    return _filterBookingsStatus(booking) && _filterBookingsTrip(booking);
  }

  bool _filterBookingsStatus(AdminBookingModel booking) {
    switch (_currentStatus) {
      case 'all':
        return true;
      case 'pending':
        return booking.status == 'pending';
      case 'approved':
        return booking.status == 'approved';
      case 'rejected':
        return booking.status == 'rejected';
      default:
        return false;
    }
  }

  bool _filterBookingsTrip(AdminBookingModel booking) {
    if (_selectedTrip.isEmpty || _selectedTrip == 'جميع الرحلات') {
      return true;
    }
    return booking.trip.title == _selectedTrip;
  }

  void selectTrip(String trip) {
    if (_selectedTrip == trip) return;
    _selectedTrip = trip;
    _emitFilteredStates();
  }

  void selectStatus(String status) {
    if (_currentStatus == status && state is AdminBookingSuccess) return;
    _currentStatus = status;
    _emitFilteredStates();
  }
}
