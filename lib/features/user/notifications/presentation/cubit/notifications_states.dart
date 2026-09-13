import 'package:equatable/equatable.dart';
import 'package:travel_app/features/user/notifications/data/models/notification_model.dart';

abstract class NotificationsStates extends Equatable {
  const NotificationsStates();

  @override
  List<Object?> get props => [];
}

class NotificationsInitialStates extends NotificationsStates {
  const NotificationsInitialStates();
}

class NotificationsLoadingStates extends NotificationsStates {
  const NotificationsLoadingStates();
}

class NotificationsSuccessStates extends NotificationsStates {
  final NotificationsPageData pageData;
  final List<NotificationModel> notifications;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final int unreadCount;
  final bool hasMore;
  final bool isLoadingMore;

  const NotificationsSuccessStates({
    required this.pageData,
    required this.notifications,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    required this.unreadCount,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  NotificationsSuccessStates copyWith({
    NotificationsPageData? pageData,
    List<NotificationModel>? notifications,
    int? totalPages,
    int? currentPage,
    int? pageSize,
    int? totalItems,
    int? unreadCount,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return NotificationsSuccessStates(
      pageData: pageData ?? this.pageData,
      notifications: notifications ?? this.notifications,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
      unreadCount: unreadCount ?? this.unreadCount,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    pageData,
    notifications,
    totalPages,
    currentPage,
    pageSize,
    totalItems,
    unreadCount,
    hasMore,
    isLoadingMore,
  ];
}

class NotificationsErrorStates extends NotificationsStates {
  final String message;

  const NotificationsErrorStates({required this.message});

  @override
  List<Object?> get props => [message];
}

class NotificationsMarkNotificationAsReadSuccessStates
    extends NotificationsStates {
  final NotificationModel notification;

  const NotificationsMarkNotificationAsReadSuccessStates({
    required this.notification,
  });

  @override
  List<Object?> get props => [notification];
}

class NotificationsMarkAllNotificationsAsReadSuccessStates
    extends NotificationsStates {
  const NotificationsMarkAllNotificationsAsReadSuccessStates();

  @override
  List<Object?> get props => [];
}

class NotificationsMarkNotificationAsReadErrorStates
    extends NotificationsStates {
  final String message;

  const NotificationsMarkNotificationAsReadErrorStates({required this.message});

  @override
  List<Object?> get props => [message];
}

class NotificationsMarkAllNotificationsAsReadErrorStates
    extends NotificationsStates {
  final String message;

  const NotificationsMarkAllNotificationsAsReadErrorStates({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
