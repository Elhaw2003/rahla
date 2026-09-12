import 'package:flutter/material.dart';
import 'package:travel_app/core/constants/app_colors.dart';

/// GET `/bookings/my` response wrapper.
class UserBookingsResponseModel {
  final int statusCode;
  final bool success;
  final String code;
  final String message;
  final UserBookingsPageData? data;

  const UserBookingsResponseModel({
    required this.statusCode,
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory UserBookingsResponseModel.fromJson(Map<String, dynamic> json) {
    return UserBookingsResponseModel(
      statusCode: json['statusCode'] as int? ?? 0,
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: json['data'] == null
          ? null
          : UserBookingsPageData.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            ),
    );
  }
}

class UserBookingsPageData {
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final List<UserBookingModel> bookings;

  const UserBookingsPageData({
    this.totalItems = 0,
    this.totalPages = 0,
    this.currentPage = 1,
    this.pageSize = 10,
    this.bookings = const [],
  });

  factory UserBookingsPageData.fromJson(Map<String, dynamic> json) {
    final rawBookings = json['bookings'] as List? ?? const [];
    return UserBookingsPageData(
      totalItems: json['totalItems'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      currentPage: json['currentPage'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 10,
      bookings: rawBookings
          .whereType<Map>()
          .map(
            (item) => UserBookingModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
    );
  }
}

/// POST `/bookings` response wrapper.
class CreateUserBookingResponseModel {
  final int statusCode;
  final bool success;
  final String code;
  final String message;
  final UserBookingModel? data;

  const CreateUserBookingResponseModel({
    required this.statusCode,
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory CreateUserBookingResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateUserBookingResponseModel(
      statusCode: json['statusCode'] as int? ?? 0,
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: json['data'] == null
          ? null
          : UserBookingModel.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            ),
    );
  }
}

/// GET `/bookings/:id` response wrapper.
class UserBookingDetailsResponseModel {
  final int statusCode;
  final bool success;
  final String code;
  final String message;
  final UserBookingModel? data;

  const UserBookingDetailsResponseModel({
    required this.statusCode,
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory UserBookingDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return UserBookingDetailsResponseModel(
      statusCode: json['statusCode'] as int? ?? 0,
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: json['data'] == null
          ? null
          : UserBookingModel.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            ),
    );
  }
}

class UserBookingModel {
  final String id;
  final String? userId;
  final UserBookingUserModel? user;
  final UserBookingTripModel? trip;
  final int numberOfSeats;
  final double totalPrice;
  final UserTripSnapshotModel? tripSnapshot;
  final String status;
  final String notes;
  final String rejectionReason;
  final String cancellationReason;
  final bool isProtected;
  final String? createdAt;
  final String? updatedAt;
  final String? approvedAt;
  final int? v;

  const UserBookingModel({
    required this.id,
    this.userId,
    this.user,
    this.trip,
    this.numberOfSeats = 1,
    this.totalPrice = 0,
    this.tripSnapshot,
    this.status = 'pending',
    this.notes = '',
    this.rejectionReason = '',
    this.cancellationReason = '',
    this.isProtected = false,
    this.createdAt,
    this.updatedAt,
    this.approvedAt,
    this.v,
  });

  factory UserBookingModel.fromJson(Map<String, dynamic> json) {
    final userField = json['user'];
    String? userId;
    UserBookingUserModel? user;

    if (userField is String && userField.isNotEmpty) {
      userId = userField;
    } else if (userField is Map) {
      user = UserBookingUserModel.fromJson(
        Map<String, dynamic>.from(userField),
      );
      userId = user.id;
    }

    final tripField = json['trip'];
    final snapshotField = json['tripSnapshot'];

    return UserBookingModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      userId: userId,
      user: user,
      trip: tripField is Map
          ? UserBookingTripModel.fromJson(
              Map<String, dynamic>.from(tripField),
            )
          : null,
      numberOfSeats: (json['numberOfSeats'] as num?)?.toInt() ?? 1,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0,
      tripSnapshot: snapshotField is Map
          ? UserTripSnapshotModel.fromJson(
              Map<String, dynamic>.from(snapshotField),
            )
          : null,
      status: json['status'] as String? ?? 'pending',
      notes: json['notes'] as String? ?? '',
      rejectionReason: json['rejectionReason'] as String? ?? '',
      cancellationReason: json['cancellationReason'] as String? ?? '',
      isProtected: json['isProtected'] as bool? ?? false,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      approvedAt: json['approvedAt'] as String?,
      v: json['__v'] as int?,
    );
  }

  String get title {
    final snapshotTitle = tripSnapshot?.title?.trim();
    if (snapshotTitle != null && snapshotTitle.isNotEmpty) return snapshotTitle;
    final tripTitle = trip?.title?.trim();
    if (tripTitle != null && tripTitle.isNotEmpty) return tripTitle;
    return '';
  }

  String get coverImage {
    final snapshotImage = tripSnapshot?.coverImage?.trim();
    if (snapshotImage != null && snapshotImage.isNotEmpty) {
      return _fullImageUrl(snapshotImage);
    }
    final tripImage = trip?.coverImage?.trim();
    if (tripImage != null && tripImage.isNotEmpty) {
      return _fullImageUrl(tripImage);
    }
    return '';
  }

  String get origin =>
      tripSnapshot?.origin?.trim().isNotEmpty == true
      ? tripSnapshot!.origin!
      : (trip?.origin?.trim() ?? '');

  String get destination =>
      tripSnapshot?.destination?.trim().isNotEmpty == true
      ? tripSnapshot!.destination!
      : (trip?.destination?.trim() ?? '');

  String get statusLabel {
    switch (status) {
      case 'approved':
        return 'مقبول';
      case 'pending':
        return 'قيد الانتظار';
      case 'cancelled':
        return 'ملغى';
      case 'rejected':
        return 'مرفوض';
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'approved':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'cancelled':
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  Color get statusBg => statusColor.withValues(alpha: 0.1);

  String get formattedCreatedAt {
    final value = createdAt;
    if (value == null || value.isEmpty) return '';
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    return '${parsed.day}/${parsed.month}/${parsed.year}';
  }

  String get durationLabel {
    final startRaw = tripSnapshot?.startDate ?? trip?.startDate;
    final endRaw = tripSnapshot?.endDate ?? trip?.endDate;
    if (startRaw == null ||
        startRaw.isEmpty ||
        endRaw == null ||
        endRaw.isEmpty) {
      return '';
    }

    final start = DateTime.tryParse(startRaw);
    final end = DateTime.tryParse(endRaw);
    if (start == null || end == null) return '';

    final days = end.difference(start).inDays.abs();
    if (days <= 1) return '1 يوم / 1 ليلة';
    return '$days أيام / ${days - 1} ليلة';
  }

  static String _fullImageUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    return 'https://rahala.duckdns.org$path';
  }
}

class UserBookingUserModel {
  final String? id;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? profileImage;

  const UserBookingUserModel({
    this.id,
    this.fullName,
    this.email,
    this.phone,
    this.profileImage,
  });

  factory UserBookingUserModel.fromJson(Map<String, dynamic> json) {
    return UserBookingUserModel(
      id: json['_id'] as String? ?? json['id'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      profileImage: json['profileImage'] as String?,
    );
  }
}

class UserBookingTripModel {
  final String? id;
  final String? title;
  final String? origin;
  final String? destination;
  final double price;
  final String? startDate;
  final String? endDate;
  final String? status;
  final String? coverImage;

  const UserBookingTripModel({
    this.id,
    this.title,
    this.origin,
    this.destination,
    this.price = 0,
    this.startDate,
    this.endDate,
    this.status,
    this.coverImage,
  });

  factory UserBookingTripModel.fromJson(Map<String, dynamic> json) {
    return UserBookingTripModel(
      id: json['_id'] as String? ?? json['id'] as String?,
      title: json['title'] as String?,
      origin: json['origin'] as String?,
      destination: json['destination'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      status: json['status'] as String?,
      coverImage: json['coverImage'] as String?,
    );
  }
}

class UserTripSnapshotModel {
  final String? title;
  final String? coverImage;
  final String? origin;
  final String? destination;
  final String? startDate;
  final String? endDate;
  final double pricePerSeat;

  const UserTripSnapshotModel({
    this.title,
    this.coverImage,
    this.origin,
    this.destination,
    this.startDate,
    this.endDate,
    this.pricePerSeat = 0,
  });

  factory UserTripSnapshotModel.fromJson(Map<String, dynamic> json) {
    return UserTripSnapshotModel(
      title: json['title'] as String?,
      coverImage: json['coverImage'] as String?,
      origin: json['origin'] as String?,
      destination: json['destination'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      pricePerSeat: (json['pricePerSeat'] as num?)?.toDouble() ?? 0,
    );
  }
}
