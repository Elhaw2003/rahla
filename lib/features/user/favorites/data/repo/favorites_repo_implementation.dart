import 'package:dartz/dartz.dart';
import 'package:travel_app/core/errors/exceptions.dart';
import 'package:travel_app/core/errors/failure.dart';
import 'package:travel_app/core/errors/failure_mapper.dart';
import 'package:travel_app/core/networking/api_consumer.dart';
import 'package:travel_app/core/networking/end_points.dart';
import 'package:travel_app/features/user/favorites/data/models/favorite_model.dart';
import 'package:travel_app/features/user/favorites/data/repo/favorites_repo.dart';

class FavoritesRepoImplementation extends FavoritesRepo {
  FavoritesRepoImplementation({required ApiConsumer apiConsumer})
    : _apiConsumer = apiConsumer;

  final ApiConsumer _apiConsumer;

  @override
  Future<Either<Failure, FavoritesPageData>> getFavorites(
    int page,
    int limit,
  ) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getFavorites,
        queryParameters: {'page': page, 'limit': limit},
      );
      final json = Map<String, dynamic>.from(response as Map);
      final data = FavoriteResponseModel.fromJson(json).data;
      return Right(data ?? FavoritesPageData());
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ToggleFavoriteModel>> toggleFavorite({
    required String tripId,
  }) async {
    try {
      final response = await _apiConsumer.post(
        EndPoints.toggleFavorite(tripId),
      );
      final toggleFavoriteModel = ToggleFavoriteModel.fromJson(
        Map<String, dynamic>.from(response as Map),
      );
      return Right(toggleFavoriteModel);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
