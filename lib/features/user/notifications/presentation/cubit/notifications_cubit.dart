import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/features/user/notifications/data/models/notification_model.dart';
import 'package:travel_app/features/user/notifications/data/repo/notifications_repo.dart';
import 'package:travel_app/features/user/notifications/presentation/cubit/notifications_states.dart';

class NotificationsCubit extends Cubit<NotificationsStates> {
  NotificationsCubit({required NotificationsRepo notificationsRepo})
    : _notificationsRepo = notificationsRepo,
      super(const NotificationsInitialStates());

  final NotificationsRepo _notificationsRepo;

  NotificationsPageData _pageData = const NotificationsPageData();
  List<NotificationModel> _notifications = [];
  int _totalPages = 0;
  int _currentPage = 1;
  final int _pageSize = 10;
  int _totalItems = 0;
  int _unreadCount = 0;
  bool _hasMore = false;

  Future<void> getNotifications() async {
    _currentPage = 1;
    emit(const NotificationsLoadingStates());

    final result = await _notificationsRepo.getNotifications(
      page: _currentPage,
      limit: _pageSize,
    );

    result.fold(
      (failure) => emit(NotificationsErrorStates(message: failure.message)),
      (data) {
        _pageData = data;
        _notifications = List<NotificationModel>.from(data.notifications);
        _totalItems = data.totalItems;
        _totalPages = data.totalPages;
        _currentPage = data.currentPage == 0 ? 1 : data.currentPage;
        _unreadCount = data.unreadCount;
        _hasMore = data.totalPages > 0 && _currentPage < data.totalPages;
        emit(_success());
      },
    );
  }

  Future<void> loadMoreNotifications() async {
    final current = state;
    if (current is! NotificationsSuccessStates) return;
    if (!current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));

    final nextPage = _currentPage + 1;
    final result = await _notificationsRepo.getNotifications(
      page: nextPage,
      limit: _pageSize,
    );

    result.fold((failure) => emit(current.copyWith(isLoadingMore: false)), (
      data,
    ) {
      _pageData = data;
      _notifications = List<NotificationModel>.from(_notifications)
        ..addAll(data.notifications);
      _totalItems = data.totalItems;
      _totalPages = data.totalPages;
      _currentPage = data.currentPage == 0 ? nextPage : data.currentPage;
      _unreadCount = data.unreadCount;
      _hasMore = data.totalPages > 0 && _currentPage < data.totalPages;
      emit(_success(isLoadingMore: false));
    });
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final id = notificationId.trim();
    if (id.isEmpty) return;
    final index = _notifications.indexWhere(
      (notification) => notification.id == id,
    );
    if (index == -1) return;
    final previous = _notifications[index];
    if (previous.isRead) return;
    final previousUnread = _unreadCount;
    _notifications = List<NotificationModel>.from(_notifications);
    _notifications[index] = previous.copyWith(isRead: true);
    if (_unreadCount > 0) _unreadCount -= 1;
    emit(_success());
    final result = await _notificationsRepo.markNotificationAsRead(id);
    result.fold(
      (failure) {
        _notifications = List<NotificationModel>.from(_notifications);
        _notifications[index] = previous;
        _unreadCount = previousUnread;
        emit(
          NotificationsMarkNotificationAsReadErrorStates(
            message: failure.message,
          ),
        );
        emit(_success());
      },
      (notification) {
        _notifications = List<NotificationModel>.from(_notifications);
        _notifications[index] = notification.copyWith(isRead: true);
        emit(
          NotificationsMarkNotificationAsReadSuccessStates(
            notification: notification,
          ),
        );
        emit(_success());
      },
    );
  }

  Future<void> markAllNotificationsAsRead() async {
    if (_unreadCount <= 0) return;
    final previousUnreadCount = _unreadCount;
    final previousList = List<NotificationModel>.from(_notifications);
    _notifications = _notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    _unreadCount = 0;
    emit(_success());
    final result = await _notificationsRepo.markAllNotificationsAsRead();
    result.fold(
      (failure) {
        _notifications = previousList;
        _unreadCount = previousUnreadCount;
        emit(
          NotificationsMarkAllNotificationsAsReadErrorStates(
            message: failure.message,
          ),
        );
        emit(_success());
      },
      (_) {
        emit(const NotificationsMarkAllNotificationsAsReadSuccessStates());
        emit(_success());
      },
    );
  }

  NotificationsSuccessStates _success({bool isLoadingMore = false}) {
    return NotificationsSuccessStates(
      pageData: _pageData,
      notifications: List<NotificationModel>.from(_notifications),
      totalPages: _totalPages,
      currentPage: _currentPage,
      pageSize: _pageSize,
      totalItems: _totalItems,
      unreadCount: _unreadCount,
      hasMore: _hasMore,
      isLoadingMore: isLoadingMore,
    );
  }
}
