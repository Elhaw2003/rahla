class CategoriesResponseModel {
  final int statusCode;
  final bool success;
  final String code;
  final String message;
  final List<CategoryModel> data;

  CategoriesResponseModel({
    required this.statusCode,
    required this.success,
    required this.code,
    required this.message,
    this.data = const [],
  });

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoriesResponseModel(
      statusCode: json['statusCode'] as int? ?? 0,
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: (json['data'] as List?)
              ?.map(
                (item) => CategoryModel.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList() ??
          const [],
    );
  }
}

class CategoryModel {
  final String? id;
  final String? nameEn;
  final String? nameAr;
  final String? slug;
  final String? image;
  final bool isActive;
  final bool isProtected;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  CategoryModel({
    this.id,
    this.nameEn,
    this.nameAr,
    this.slug,
    this.image,
    this.isActive = true,
    this.isProtected = false,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] as String?,
      nameEn: json['nameEn'] as String?,
      nameAr: json['nameAr'] as String?,
      slug: json['slug'] as String?,
      image: json['image'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      isProtected: json['isProtected'] as bool? ?? false,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
    );
  }

  String get displayName => nameAr?.isNotEmpty == true
      ? nameAr!
      : (nameEn ?? '');
}
