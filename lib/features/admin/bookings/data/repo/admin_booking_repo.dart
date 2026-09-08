import 'package:dartz/dartz.dart';
import 'package:travel_app/core/errors/exceptions.dart';
import 'package:travel_app/core/errors/failure.dart';
import 'package:travel_app/core/errors/failure_mapper.dart';
import 'package:travel_app/core/networking/api_consumer.dart';
import 'package:travel_app/core/networking/end_points.dart';
import 'package:travel_app/features/admin/bookings/data/models/admin_booking_model.dart';

class AdminBookingRepo {
  final ApiConsumer apiConsumer;
  AdminBookingRepo({required this.apiConsumer});
  Future<Either<Failure, AdminBookingDataModel>> getAdminBookings({
    int page = 1,
    int limit = 2,
    String? status,
  }) async {
    try {
      final queryParam = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (status != null && status.isNotEmpty && status != 'all')
          'status': status,
      };
      final response = await apiConsumer.get(
        EndPoints.adminBookings,
        queryParameters: queryParam,
      );
      final json = Map<String, dynamic>.from(response as Map);
      final data = json['data'];
      if (data is! Map) {
        return Left(UnexpectedFailure('Invalid bookings response'));
      }
      return Right(
        AdminBookingDataModel.fromJson(Map<String, dynamic>.from(data)),
      );
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<Either<Failure, AdminBookingModel>> approveBooking(
    String bookingId,
  ) async {
    try {
      final response = await apiConsumer.patch(
        EndPoints.approveBooking(bookingId),
      );
      final json = Map<String, dynamic>.from(response as Map);
      final data = json['data'];
      if (data is! Map) {
        return Left(UnexpectedFailure('Invalid booking response'));
      }
      return Right(AdminBookingModel.fromJson(Map<String, dynamic>.from(data)));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  Future<Either<Failure, AdminBookingModel>> rejectBooking(
    String bookingId,
  ) async {
    try {
      final response = await apiConsumer.patch(
        EndPoints.rejectBooking(bookingId),
      );
      final json = Map<String, dynamic>.from(response as Map);
      final data = json['data'];
      if (data is! Map) {
        return Left(UnexpectedFailure('Invalid booking response'));
      }
      return Right(AdminBookingModel.fromJson(Map<String, dynamic>.from(data)));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
