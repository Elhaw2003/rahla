import 'package:dartz/dartz.dart';
import 'package:travel_app/core/errors/exceptions.dart';
import 'package:travel_app/core/errors/failure.dart';
import 'package:travel_app/core/errors/failure_mapper.dart';
import 'package:travel_app/core/networking/api_consumer.dart';
import 'package:travel_app/core/networking/end_points.dart';
import 'package:travel_app/features/user/notifications/data/models/notification_model.dart';
import 'package:travel_app/features/user/notifications/data/repo/notifications_repo.dart';

class NotificationsRepoImplementation implements NotificationsRepo {
  NotificationsRepoImplementation({required ApiConsumer apiConsumer})
    : _apiConsumer = apiConsumer;

  final ApiConsumer _apiConsumer;

  @override
  Future<Either<Failure, NotificationsPageData>> getNotifications({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getNotifications,
        queryParameters: {'page': page, 'limit': limit},
      );
      final json = Map<String, dynamic>.from(response as Map);
      final data = NotificationsResponseModel.fromJson(json).data;
      return Right(data ?? const NotificationsPageData());
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationModel>> markNotificationAsRead(
    String notificationId,
  ) async {
    try {
      final response = await _apiConsumer.patch(
        EndPoints.markNotificationAsRead(notificationId),
      );
      final json = Map<String, dynamic>.from(response as Map);
      final rawData = json['data'];
      final notification = rawData is Map
          ? NotificationModel.fromJson(Map<String, dynamic>.from(rawData))
          : NotificationModel.fromJson(json);
      return Right(notification);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllNotificationsAsRead() async {
    try {
      await _apiConsumer.patch(EndPoints.markAllNotificationsAsRead());
      return const Right(null);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
