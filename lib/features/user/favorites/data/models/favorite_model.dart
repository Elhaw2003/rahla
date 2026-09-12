import 'package:travel_app/features/admin/trips/data/models/admin_trips_model.dart';

class FavoriteResponseModel {
  final int statusCode;
  final bool success;
  final String code;
  final String message;
  final FavoritesPageData? data;

  FavoriteResponseModel({
    required this.statusCode,
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory FavoriteResponseModel.fromJson(Map<String, dynamic> json) {
    return FavoriteResponseModel(
      statusCode: json['statusCode'] as int? ?? 0,
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: json['data'] == null
          ? null
          : FavoritesPageData.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            ),
    );
  }
}

/// Paginated favorites payload, mapped to [AdminTripModel] only.
class FavoritesPageData {
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final List<AdminTripModel> favorites;

  FavoritesPageData({
    this.totalItems = 0,
    this.totalPages = 0,
    this.currentPage = 1,
    this.pageSize = 10,
    this.favorites = const [],
  });

  factory FavoritesPageData.fromJson(Map<String, dynamic> json) {
    final rawFavorites = json['favorites'] as List? ?? const [];
    final trips = <AdminTripModel>[];

    for (final item in rawFavorites) {
      if (item is! Map) continue;
      final tripJson = item['trip'];
      if (tripJson is! Map) continue;
      trips.add(
        AdminTripModel.fromJson(
          Map<String, dynamic>.from(tripJson),
        ).copyWith(isFavorite: true),
      );
    }

    return FavoritesPageData(
      totalItems: json['totalItems'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      currentPage: json['currentPage'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 10,
      favorites: trips,
    );
  }
}

class ToggleFavoriteModel {
  final int statusCode;
  final bool success;
  final String code;
  final String message;
  final bool isFavorite;
  final String action;

  ToggleFavoriteModel({
    required this.statusCode,
    required this.success,
    required this.code,
    required this.message,
    required this.isFavorite,
    required this.action,
  });

  factory ToggleFavoriteModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : <String, dynamic>{};
    return ToggleFavoriteModel(
      statusCode: json['statusCode'] as int? ?? 0,
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      isFavorite: data['isFavorite'] as bool? ?? false,
      action: data['action'] as String? ?? '',
    );
  }
}
