import 'package:dartz/dartz.dart';
import 'package:travel_app/core/errors/failure.dart';
import 'package:travel_app/features/user/notifications/data/models/notification_model.dart';

abstract class NotificationsRepo {
  Future<Either<Failure, NotificationsPageData>> getNotifications({
    required int page,
    required int limit,
  });
  Future<Either<Failure, NotificationModel>> markNotificationAsRead(
    String notificationId,
  );
  Future<Either<Failure, void>> markAllNotificationsAsRead();
}
