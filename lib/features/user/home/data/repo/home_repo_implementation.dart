import 'package:dartz/dartz.dart';
import 'package:travel_app/core/errors/exceptions.dart';
import 'package:travel_app/core/errors/failure.dart';
import 'package:travel_app/core/errors/failure_mapper.dart';
import 'package:travel_app/core/networking/api_consumer.dart';
import 'package:travel_app/core/networking/end_points.dart';
import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';
import 'package:travel_app/features/user/home/data/models/offer_model.dart';
import 'package:travel_app/features/user/home/data/repo/home_repo.dart';

class HomeRepoImplementation implements HomeRepo {
  final ApiConsumer _apiConsumer;

  const HomeRepoImplementation({required ApiConsumer apiConsumer})
    : _apiConsumer = apiConsumer;

  @override
  Future<Either<Failure, List<OfferModel>>> getOffers() async {
    try {
      final response = await _apiConsumer.get(EndPoints.getActiveOffer);
      final json = Map<String, dynamic>.from(response as Map);
      final offers = OffersResponseModel.fromJson(json).data;
      return Right(offers);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminTripsData>> getTrips({
    int page = 1,
    int limit = 5,
    String sort = 'newest',
  }) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getTrips,
        queryParameters: {'page': page, 'limit': limit, 'sort': sort},
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
