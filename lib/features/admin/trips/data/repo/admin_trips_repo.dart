import 'package:dartz/dartz.dart';
import 'package:travel_app/core/errors/exceptions.dart';
import 'package:travel_app/core/errors/failure.dart';
import 'package:travel_app/core/errors/failure_mapper.dart';
import 'package:travel_app/core/networking/api_consumer.dart';
import 'package:travel_app/core/networking/end_points.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';

abstract class AdminTripsRepo {
  Future<Either<Failure, AdminTripsModel>> getAdminTrips({
    int page = 1,
    int limit = 10,
    String? status,
  });
}

class AdminTripsRepoImpl implements AdminTripsRepo {
  final ApiConsumer apiConsumer;

  AdminTripsRepoImpl({required this.apiConsumer});

  @override
  Future<Either<Failure, AdminTripsModel>> getAdminTrips({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (status != null && status.isNotEmpty) 'status': status,
      };

      final response = await apiConsumer.get(
        EndPoints.adminTrips,
        queryParameters: queryParameters,
      );

      return Right(
        AdminTripsModel.fromJson(
          Map<String, dynamic>.from(response as Map),
        ),
      );
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
