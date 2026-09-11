import 'package:dartz/dartz.dart';
import 'package:travel_app/core/errors/exceptions.dart';
import 'package:travel_app/core/errors/failure.dart';
import 'package:travel_app/core/errors/failure_mapper.dart';
import 'package:travel_app/core/networking/api_consumer.dart';
import 'package:travel_app/core/networking/end_points.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';
import 'package:travel_app/features/user/explore/data/repo/explore_repo.dart';

class ExploreRepoImplementation implements ExploreRepo {
  final ApiConsumer apiConsumer;
  ExploreRepoImplementation({required this.apiConsumer});
  @override
  Future<Either<Failure, AdminTripsData>> getTripsFiltered(
    String category, {
    int page = 1,
    int limit = 5,
  }) async {
    try {
      final response = await apiConsumer.get(
        EndPoints.getTrips,
        queryParameters: {'category': category, 'page': page, 'limit': 5},
      );
      final json = Map<String, dynamic>.from(response as Map);
      final data = AdminTripsModel.fromJson(json).data;
      return Right(data ?? AdminTripsData());
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
