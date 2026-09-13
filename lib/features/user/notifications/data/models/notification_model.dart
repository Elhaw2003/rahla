/// GET `/notifications` response wrapper.
class NotificationsResponseModel {
  final int statusCode;
  final bool success;
  final String code;
  final String message;
  final NotificationsPageData? data;

  const NotificationsResponseModel({
    required this.statusCode,
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationsResponseModel(
      statusCode: json['statusCode'] as int? ?? 0,
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: json['data'] == null
          ? null
          : NotificationsPageData.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            ),
    );
  }
}

class NotificationsPageData {
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final List<NotificationModel> notifications;
  final int unreadCount;

  const NotificationsPageData({
    this.totalItems = 0,
    this.totalPages = 0,
    this.currentPage = 1,
    this.pageSize = 10,
    this.notifications = const [],
    this.unreadCount = 0,
  });

  factory NotificationsPageData.fromJson(Map<String, dynamic> json) {
    final raw = json['notifications'] as List? ?? const [];
    return NotificationsPageData(
      totalItems: json['totalItems'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      currentPage: json['currentPage'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 10,
      notifications: raw
          .whereType<Map>()
          .map(
            (item) => NotificationModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }
}

class NotificationModel {
  final String id;
  final String? userId;
  final String title;
  final String body;
  final String type;
  final NotificationPayloadModel? data;
  final bool isRead;
  final bool isProtected;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  const NotificationModel({
    required this.id,
    this.userId,
    this.title = '',
    this.body = '',
    this.type = '',
    this.data,
    this.isRead = false,
    this.isProtected = false,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final userField = json['user'];
    String? userId;
    if (userField is String && userField.isNotEmpty) {
      userId = userField;
    } else if (userField is Map) {
      userId =
          userField['_id'] as String? ?? userField['id'] as String?;
    }

    final payloadField = json['data'];

    return NotificationModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      userId: userId,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      type: json['type'] as String? ?? '',
      data: payloadField is Map
          ? NotificationPayloadModel.fromJson(
              Map<String, dynamic>.from(payloadField),
            )
          : null,
      isRead: json['isRead'] as bool? ?? false,
      isProtected: json['isProtected'] as bool? ?? false,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
    );
  }

  bool get isPromo => type == 'promo';
  bool get isBooking => type == 'booking';

  String get formattedCreatedAt {
    final value = createdAt;
    if (value == null || value.isEmpty) return '';
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    return '${parsed.day}/${parsed.month}/${parsed.year}';
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    String? type,
    NotificationPayloadModel? data,
    bool? isRead,
    bool? isProtected,
    String? createdAt,
    String? updatedAt,
    int? v,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      isProtected: isProtected ?? this.isProtected,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }
}

/// Extra payload attached to some notification types (e.g. booking).
class NotificationPayloadModel {
  final String? bookingId;
  final String? tripId;

  const NotificationPayloadModel({
    this.bookingId,
    this.tripId,
  });

  factory NotificationPayloadModel.fromJson(Map<String, dynamic> json) {
    return NotificationPayloadModel(
      bookingId: json['bookingId'] as String?,
      tripId: json['tripId'] as String?,
    );
  }
}
