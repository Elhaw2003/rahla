import 'package:equatable/equatable.dart';
import 'package:travel_app/features/user/user_booking/data/models/user_booking_model.dart';

abstract class UserBookingStates extends Equatable {
  const UserBookingStates();

  @override
  List<Object?> get props => [];
}

class UserBookingInitialStates extends UserBookingStates {
  const UserBookingInitialStates();
}

class UserBookingLoadingStates extends UserBookingStates {
  const UserBookingLoadingStates();
}

class UserBookingSuccessStates extends UserBookingStates {
  final UserBookingsPageData userBookings;
  final List<UserBookingModel> userBookingsList;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final bool hasMore;
  final bool isLoadingMore;

  const UserBookingSuccessStates({
    required this.userBookings,
    required this.userBookingsList,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  UserBookingSuccessStates copyWith({
    UserBookingsPageData? userBookings,
    List<UserBookingModel>? userBookingsList,
    int? totalPages,
    int? currentPage,
    int? pageSize,
    int? totalItems,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return UserBookingSuccessStates(
      userBookings: userBookings ?? this.userBookings,
      userBookingsList: userBookingsList ?? this.userBookingsList,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    userBookings,
    userBookingsList,
    totalPages,
    currentPage,
    pageSize,
    totalItems,
    hasMore,
    isLoadingMore,
  ];
}

class UserBookingErrorStates extends UserBookingStates {
  final String message;

  const UserBookingErrorStates({required this.message});

  @override
  List<Object?> get props => [message];
}

class UserBookingCreateLoadingStates extends UserBookingStates {
  const UserBookingCreateLoadingStates();
}

class UserBookingCreateSuccessStates extends UserBookingStates {
  final UserBookingModel userBooking;
  final String message;

  const UserBookingCreateSuccessStates({
    required this.userBooking,
    required this.message,
  });

  @override
  List<Object?> get props => [userBooking, message];
}

class UserBookingCreateErrorStates extends UserBookingStates {
  final String message;

  const UserBookingCreateErrorStates({required this.message});

  @override
  List<Object?> get props => [message];
}

class UserBookingDetailsLoadingStates extends UserBookingStates {
  const UserBookingDetailsLoadingStates();
}

class UserBookingDetailsSuccessStates extends UserBookingStates {
  final UserBookingModel booking;

  const UserBookingDetailsSuccessStates({required this.booking});

  @override
  List<Object?> get props => [booking];
}

class UserBookingDetailsErrorStates extends UserBookingStates {
  final String message;

  const UserBookingDetailsErrorStates({required this.message});

  @override
  List<Object?> get props => [message];
}
