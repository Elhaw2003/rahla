import 'package:dartz/dartz.dart';
import 'package:travel_app/core/errors/exceptions.dart';
import 'package:travel_app/core/errors/failure.dart';
import 'package:travel_app/core/errors/failure_mapper.dart';
import 'package:travel_app/core/networking/api_consumer.dart';
import 'package:travel_app/core/networking/end_points.dart';
import 'package:travel_app/features/admin/dashboard/data/models/admin_dashboard_stats_model.dart';

abstract class DashboardRepo {
  Future<Either<Failure, AdminDashboardStatsModel>> getAdminStats();
}

class DashboardRepoImpl implements DashboardRepo {
  final ApiConsumer apiConsumer;
  DashboardRepoImpl({required this.apiConsumer});
  @override
  Future<Either<Failure, AdminDashboardStatsModel>> getAdminStats() async {
    try {
      final response = await apiConsumer.get(EndPoints.adminStats);
      AdminDashboardStatsModel adminStatsModel =
          AdminDashboardStatsModel.fromJson(
            Map<String, dynamic>.from(response as Map),
          );
      return Right(adminStatsModel);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
