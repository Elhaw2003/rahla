import 'package:dartz/dartz.dart';
import 'package:travel_app/core/errors/failure.dart';
import 'package:travel_app/features/user/user_booking/data/models/user_booking_model.dart';

abstract class UserBookingRepo {
  Future<Either<Failure, UserBookingsPageData>> getUserBookings({
    required int page,
    required int limit,
  });

  Future<Either<Failure, CreateUserBookingResponseModel>> createUserBooking({
    required String tripId,
    required int numberOfSeats,
    String? notes,
    String? couponCode,
  });

  Future<Either<Failure, UserBookingModel>> getUserBookingById({
    required String bookingId,
  });
}
