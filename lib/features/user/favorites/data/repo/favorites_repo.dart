import 'package:dartz/dartz.dart';
import 'package:travel_app/core/errors/failure.dart';
import 'package:travel_app/features/user/favorites/data/models/favorite_model.dart';

abstract class FavoritesRepo {
  Future<Either<Failure, FavoritesPageData>> getFavorites(int page, int limit);

  Future<Either<Failure, ToggleFavoriteModel>> toggleFavorite({
    required String tripId,
  });
}
