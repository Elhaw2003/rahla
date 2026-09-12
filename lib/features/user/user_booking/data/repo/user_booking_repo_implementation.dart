import 'package:dartz/dartz.dart';
import 'package:travel_app/core/errors/exceptions.dart';
import 'package:travel_app/core/errors/failure.dart';
import 'package:travel_app/core/errors/failure_mapper.dart';
import 'package:travel_app/core/networking/api_consumer.dart';
import 'package:travel_app/core/networking/end_points.dart';
import 'package:travel_app/features/user/user_booking/data/models/user_booking_model.dart';
import 'package:travel_app/features/user/user_booking/data/repo/user_booking_repo.dart';

class UserBookingRepoImplementation implements UserBookingRepo {
  UserBookingRepoImplementation({required ApiConsumer apiConsumer})
    : _apiConsumer = apiConsumer;

  final ApiConsumer _apiConsumer;

  @override
  Future<Either<Failure, UserBookingsPageData>> getUserBookings({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getUserBookings,
        queryParameters: {'page': page, 'limit': limit},
      );
      final json = Map<String, dynamic>.from(response as Map);
      final data = UserBookingsResponseModel.fromJson(json).data;
      return Right(data ?? const UserBookingsPageData());
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CreateUserBookingResponseModel>> createUserBooking({
    required String tripId,
    required int numberOfSeats,
    String? notes,
    String? couponCode,
  }) async {
    try {
      final body = <String, dynamic>{
        'tripId': tripId,
        'numberOfSeats': numberOfSeats,
      };
      if (couponCode != null && couponCode.trim().isNotEmpty) {
        body['couponCode'] = couponCode.trim();
      }
      if (notes != null && notes.trim().isNotEmpty) {
        body['notes'] = notes.trim();
      }

      final response = await _apiConsumer.post(
        EndPoints.createUserBooking,
        data: body,
      );
      final json = Map<String, dynamic>.from(response as Map);
      final created = CreateUserBookingResponseModel.fromJson(json);
      return Right(created);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserBookingModel>> getUserBookingById({
    required String bookingId,
  }) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getUserBookingById(bookingId),
      );
      final json = Map<String, dynamic>.from(response as Map);
      final details = UserBookingDetailsResponseModel.fromJson(json);
      final booking = details.data;
      if (booking == null) {
        return const Left(UnexpectedFailure('Booking data is missing'));
      }
      return Right(booking);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
