class AddTripResponseModel {
  final int statusCode;
  final bool success;
  final String code;
  final String message;
  final AddTripDataModel? data;

  AddTripResponseModel({
    required this.statusCode,
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory AddTripResponseModel.fromJson(Map<String, dynamic> json) {
    return AddTripResponseModel(
      statusCode: json['statusCode'] as int? ?? 0,
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: json['data'] == null
          ? null
          : AddTripDataModel.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            ),
    );
  }
}

class AddTripDataModel {
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
  final String? category;
  final String? status;
  final bool createdBySystem;
  final bool isProtected;
  final bool isDeleted;
  final String? coverImage;
  final List<String> gallery;
  final List<String> included;
  final List<String> excluded;
  final String? cancelPolicy;
  final num averageRating;
  final int reviewsCount;
  final List<AddTripDayResponseModel> days;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  AddTripDataModel({
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
    this.isDeleted = false,
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
  });

  factory AddTripDataModel.fromJson(Map<String, dynamic> json) {
    return AddTripDataModel(
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
      category: json['category']?.toString(),
      status: json['status'] as String?,
      createdBySystem: json['createdBySystem'] as bool? ?? false,
      isProtected: json['isProtected'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
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
                (item) => AddTripDayResponseModel.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList() ??
          const [],
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
    );
  }
}

class AddTripDayResponseModel {
  final String? id;
  final int dayNumber;
  final String? title;
  final List<AddTripActivityResponseModel> activities;

  AddTripDayResponseModel({
    this.id,
    this.dayNumber = 0,
    this.title,
    this.activities = const [],
  });

  factory AddTripDayResponseModel.fromJson(Map<String, dynamic> json) {
    return AddTripDayResponseModel(
      id: json['_id'] as String?,
      dayNumber: json['dayNumber'] as int? ?? 0,
      title: json['title'] as String?,
      activities:
          (json['activities'] as List?)
              ?.map(
                (item) => AddTripActivityResponseModel.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList() ??
          const [],
    );
  }
}

class AddTripActivityResponseModel {
  final String? id;
  final String? time;
  final String? title;
  final String? description;
  final String? location;
  final String? image;

  AddTripActivityResponseModel({
    this.id,
    this.time,
    this.title,
    this.description,
    this.location,
    this.image,
  });

  factory AddTripActivityResponseModel.fromJson(Map<String, dynamic> json) {
    return AddTripActivityResponseModel(
      id: json['_id'] as String?,
      time: json['time'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      location: json['location'] as String?,
      image: json['image'] as String?,
    );
  }
}
