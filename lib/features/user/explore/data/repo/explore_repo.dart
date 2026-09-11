import 'package:dartz/dartz.dart';
import 'package:travel_app/core/errors/failure.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';

abstract class ExploreRepo {
  Future<Either<Failure, AdminTripsData>> getTripsFiltered(
    String category, {
    int page = 1,
    int limit = 5,
  });
}
