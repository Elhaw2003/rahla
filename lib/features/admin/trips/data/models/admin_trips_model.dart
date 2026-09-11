class AdminTripsModel {
  final int statusCode;
  final bool success;
  final String code;
  final String message;
  final AdminTripsData? data;

  AdminTripsModel({
    required this.statusCode,
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory AdminTripsModel.fromJson(Map<String, dynamic> json) {
    return AdminTripsModel(
      statusCode: json['statusCode'] as int? ?? 0,
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: json['data'] == null
          ? null
          : AdminTripsData.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            ),
    );
  }
}

class AdminTripsData {
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final List<AdminTripModel> trips;

  AdminTripsData({
    this.totalItems = 0,
    this.totalPages = 0,
    this.currentPage = 1,
    this.pageSize = 10,
    this.trips = const [],
  });

  factory AdminTripsData.fromJson(Map<String, dynamic> json) {
    return AdminTripsData(
      totalItems: json['totalItems'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      currentPage: json['currentPage'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 10,
      trips:
          (json['trips'] as List?)
              ?.map(
                (item) => AdminTripModel.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList() ??
          const [],
    );
  }
}

class AdminTripModel {
  final String? id;
  final String? title;
  final String? description;
  final String? origin;
  final String? destination;
  final num price;
  final int capacity;
  final int availableSeats;
  final String? startDate;
  final String? endDate;
  final AdminTripCategory? category;
  final String? status;
  final bool createdBySystem;
  final bool isProtected;
  final String? coverImage;
  final List<String> gallery;
  final List<String> included;
  final List<String> excluded;
  final String? cancelPolicy;
  final num averageRating;
  final int reviewsCount;
  final List<AdminTripDay> days;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final bool isFavorite;
  final bool isBooked;
  final String? bookingStatus;

  AdminTripModel({
    this.id,
    this.title,
    this.description,
    this.origin,
    this.destination,
    this.price = 0,
    this.capacity = 0,
    this.availableSeats = 0,
    this.startDate,
    this.endDate,
    this.category,
    this.status,
    this.createdBySystem = false,
    this.isProtected = false,
    this.coverImage,
    this.gallery = const [],
    this.included = const [],
    this.excluded = const [],
    this.cancelPolicy,
    this.averageRating = 0,
    this.reviewsCount = 0,
    this.days = const [],
    this.createdAt,
    this.updatedAt,
    this.v,
    this.isFavorite = false,
    this.isBooked = false,
    this.bookingStatus,
  });

  factory AdminTripModel.fromJson(Map<String, dynamic> json) {
    return AdminTripModel(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      origin: json['origin'] as String?,
      destination: json['destination'] as String?,
      price: json['price'] as num? ?? 0,
      capacity: json['capacity'] as int? ?? 0,
      availableSeats: json['availableSeats'] as int? ?? 0,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      category: json['category'] == null
          ? null
          : AdminTripCategory.fromJson(
              Map<String, dynamic>.from(json['category'] as Map),
            ),
      status: json['status'] as String?,
      createdBySystem: json['createdBySystem'] as bool? ?? false,
      isProtected: json['isProtected'] as bool? ?? false,
      coverImage: json['coverImage'] as String?,
      gallery:
          (json['gallery'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      included:
          (json['included'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      excluded:
          (json['excluded'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      cancelPolicy: json['cancelPolicy'] as String?,
      averageRating: json['averageRating'] as num? ?? 0,
      reviewsCount: json['reviewsCount'] as int? ?? 0,
      days:
          (json['days'] as List?)
              ?.map(
                (item) => AdminTripDay.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList() ??
          const [],
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      isBooked: json['isBooked'] as bool? ?? false,
      bookingStatus: json['bookingStatus'] as String?,
    );
  }
}

class AdminTripCategory {
  final String? id;
  final String? nameEn;
  final String? nameAr;
  final String? slug;
  final String? image;

  AdminTripCategory({this.id, this.nameEn, this.nameAr, this.slug, this.image});

  factory AdminTripCategory.fromJson(Map<String, dynamic> json) {
    return AdminTripCategory(
      id: json['_id'] as String?,
      nameEn: json['nameEn'] as String?,
      nameAr: json['nameAr'] as String?,
      slug: json['slug'] as String?,
      image: json['image'] as String?,
    );
  }
}

class AdminTripDay {
  final String? id;
  final int dayNumber;
  final String? title;
  final List<AdminTripActivity> activities;

  AdminTripDay({
    this.id,
    this.dayNumber = 0,
    this.title,
    this.activities = const [],
  });

  factory AdminTripDay.fromJson(Map<String, dynamic> json) {
    return AdminTripDay(
      id: json['_id'] as String?,
      dayNumber: json['dayNumber'] as int? ?? 0,
      title: json['title'] as String?,
      activities:
          (json['activities'] as List?)
              ?.map(
                (item) => AdminTripActivity.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList() ??
          const [],
    );
  }
}

class AdminTripActivity {
  final String? id;
  final String? time;
  final String? title;
  final String? description;
  final String? location;
  final String? image;

  AdminTripActivity({
    this.id,
    this.time,
    this.title,
    this.description,
    this.location,
    this.image,
  });

  factory AdminTripActivity.fromJson(Map<String, dynamic> json) {
    return AdminTripActivity(
      id: json['_id'] as String?,
      time: json['time'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      location: json['location'] as String?,
      image: json['image'] as String?,
    );
  }
}
