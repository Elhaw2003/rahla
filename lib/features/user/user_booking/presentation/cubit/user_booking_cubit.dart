import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/features/user/user_booking/data/models/user_booking_model.dart';
import 'package:travel_app/features/user/user_booking/data/repo/user_booking_repo.dart';
import 'package:travel_app/features/user/user_booking/presentation/cubit/user_booking_states.dart';

class UserBookingCubit extends Cubit<UserBookingStates> {
  UserBookingCubit({required UserBookingRepo userBookingRepo})
    : _userBookingRepo = userBookingRepo,
      super(const UserBookingInitialStates());

  final UserBookingRepo _userBookingRepo;

  UserBookingsPageData _userBookings = const UserBookingsPageData();
  List<UserBookingModel> _userBookingsList = [];
  int _totalPages = 0;
  int _currentPage = 1;
  final int _pageSize = 10;
  int _totalItems = 0;
  bool _hasMore = false;

  Future<void> getUserBookings() async {
    _currentPage = 1;
    emit(const UserBookingLoadingStates());

    final result = await _userBookingRepo.getUserBookings(
      page: _currentPage,
      limit: _pageSize,
    );

    result.fold(
      (failure) => emit(UserBookingErrorStates(message: failure.message)),
      (data) {
        _userBookings = data;
        _userBookingsList = List<UserBookingModel>.from(data.bookings);
        _totalItems = data.totalItems;
        _totalPages = data.totalPages;
        _currentPage = data.currentPage == 0 ? 1 : data.currentPage;
        _hasMore = data.totalPages > 0 && _currentPage < data.totalPages;
        emit(_success());
      },
    );
  }

  Future<void> loadMoreUserBookings() async {
    final current = state;
    if (current is! UserBookingSuccessStates) return;
    if (!current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));

    final nextPage = _currentPage + 1;
    final result = await _userBookingRepo.getUserBookings(
      page: nextPage,
      limit: _pageSize,
    );

    result.fold(
      (failure) => emit(current.copyWith(isLoadingMore: false)),
      (data) {
        _userBookings = data;
        _userBookingsList = List<UserBookingModel>.from(_userBookingsList)
          ..addAll(data.bookings);
        _totalItems = data.totalItems;
        _totalPages = data.totalPages;
        _currentPage = data.currentPage == 0 ? nextPage : data.currentPage;
        _hasMore = data.totalPages > 0 && _currentPage < data.totalPages;
        emit(_success(isLoadingMore: false));
      },
    );
  }

  Future<void> createUserBooking({
    required String tripId,
    required int numberOfSeats,
    String? notes,
    String? couponCode,
  }) async {
    if (tripId.trim().isEmpty || numberOfSeats <= 0) return;

    emit(const UserBookingCreateLoadingStates());

    final result = await _userBookingRepo.createUserBooking(
      tripId: tripId.trim(),
      numberOfSeats: numberOfSeats,
      notes: notes,
      couponCode: couponCode,
    );

    result.fold(
      (failure) => emit(UserBookingCreateErrorStates(message: failure.message)),
      (response) {
        final booking = response.data;
        if (booking == null) {
          emit(
            const UserBookingCreateErrorStates(
              message: 'Booking created but data is missing',
            ),
          );
          return;
        }

        _userBookingsList = [booking, ..._userBookingsList];
        _totalItems += 1;

        emit(
          UserBookingCreateSuccessStates(
            userBooking: booking,
            message: response.message,
          ),
        );
        emit(_success());
      },
    );
  }

  Future<void> getUserBookingById(String bookingId) async {
    final id = bookingId.trim();
    if (id.isEmpty) {
      emit(const UserBookingDetailsErrorStates(message: 'Booking id is missing'));
      return;
    }

    emit(const UserBookingDetailsLoadingStates());

    final result = await _userBookingRepo.getUserBookingById(bookingId: id);

    result.fold(
      (failure) => emit(UserBookingDetailsErrorStates(message: failure.message)),
      (booking) => emit(UserBookingDetailsSuccessStates(booking: booking)),
    );
  }

  void restoreBookingsListState() {
    emit(_success());
  }

  UserBookingSuccessStates _success({bool isLoadingMore = false}) {
    return UserBookingSuccessStates(
      userBookings: _userBookings,
      userBookingsList: List<UserBookingModel>.from(_userBookingsList),
      totalPages: _totalPages,
      currentPage: _currentPage,
      pageSize: _pageSize,
      totalItems: _totalItems,
      hasMore: _hasMore,
      isLoadingMore: isLoadingMore,
    );
  }
}
