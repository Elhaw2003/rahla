import 'package:dartz/dartz.dart';
import 'package:travel_app/core/errors/exceptions.dart';
import 'package:travel_app/core/errors/failure.dart';
import 'package:travel_app/core/errors/failure_mapper.dart';
import 'package:travel_app/core/networking/api_consumer.dart';
import 'package:travel_app/core/networking/end_points.dart';
import 'package:travel_app/features/admin/trips/data/models/categories_response_model.dart';

abstract class CategoriesRepo {
  Future<Either<Failure, CategoriesResponseModel>> getCategories();
}

class CategoriesRepoImpl implements CategoriesRepo {
  final ApiConsumer apiConsumer;

  CategoriesRepoImpl({required this.apiConsumer});

  @override
  Future<Either<Failure, CategoriesResponseModel>> getCategories() async {
    try {
      final response = await apiConsumer.get(EndPoints.categories);
      return Right(
        CategoriesResponseModel.fromJson(
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
