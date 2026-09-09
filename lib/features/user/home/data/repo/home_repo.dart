import 'package:dartz/dartz.dart';
import 'package:travel_app/core/errors/failure.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';
import 'package:travel_app/features/user/home/data/models/offer_model.dart';

abstract class HomeRepo {
  Future<Either<Failure, AdminTripsData>> getTrips({
    int page = 1,
    int limit = 10,
    String sort = 'newest',
  });

  Future<Either<Failure, List<OfferModel>>> getOffers();
}
