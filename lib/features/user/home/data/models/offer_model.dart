class OffersResponseModel {
  final int statusCode;
  final bool success;
  final String code;
  final String message;
  final List<OfferModel> data;

  OffersResponseModel({
    this.statusCode = 0,
    this.success = false,
    this.code = '',
    this.message = '',
    this.data = const [],
  });

  factory OffersResponseModel.fromJson(Map<String, dynamic> json) {
    return OffersResponseModel(
      statusCode: json['statusCode'] as int? ?? 0,
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: (json['data'] as List?)
              ?.whereType<Map>()
              .map(
                (item) => OfferModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList() ??
          const [],
    );
  }
}

class OfferModel {
  final String? id;
  final String? titleEn;
  final String? titleAr;
  final String? descriptionEn;
  final String? descriptionAr;
  final String? image;
  final OfferTripModel? trip;
  final num discountPercentage;
  final String? promoCode;
  final int priority;
  final bool isActive;
  final bool isProtected;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  OfferModel({
    this.id,
    this.titleEn,
    this.titleAr,
    this.descriptionEn,
    this.descriptionAr,
    this.image,
    this.trip,
    this.discountPercentage = 0,
    this.promoCode,
    this.priority = 0,
    this.isActive = false,
    this.isProtected = false,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    final tripJson = json['trip'];

    return OfferModel(
      id: json['_id'] as String?,
      titleEn: json['titleEn'] as String?,
      titleAr: json['titleAr'] as String?,
      descriptionEn: json['descriptionEn'] as String?,
      descriptionAr: json['descriptionAr'] as String?,
      image: json['image'] as String?,
      trip: tripJson is Map
          ? OfferTripModel.fromJson(Map<String, dynamic>.from(tripJson))
          : null,
      discountPercentage: json['discountPercentage'] as num? ?? 0,
      promoCode: json['promoCode'] as String?,
      priority: json['priority'] as int? ?? 0,
      isActive: json['isActive'] as bool? ?? false,
      isProtected: json['isProtected'] as bool? ?? false,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
    );
  }
}

class OfferTripModel {
  final String? id;
  final String? title;
  final String? origin;
  final String? destination;
  final num price;
  final int availableSeats;
  final String? startDate;
  final String? endDate;
  final String? status;
  final String? coverImage;

  OfferTripModel({
    this.id,
    this.title,
    this.origin,
    this.destination,
    this.price = 0,
    this.availableSeats = 0,
    this.startDate,
    this.endDate,
    this.status,
    this.coverImage,
  });

  factory OfferTripModel.fromJson(Map<String, dynamic> json) {
    return OfferTripModel(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      origin: json['origin'] as String?,
      destination: json['destination'] as String?,
      price: json['price'] as num? ?? 0,
      availableSeats: json['availableSeats'] as int? ?? 0,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      status: json['status'] as String?,
      coverImage: json['coverImage'] as String?,
    );
  }
}
