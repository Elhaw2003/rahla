class LoginResponseModel {
  final int statusCode;
  final bool success;
  final String code;
  final String message;
  final LoginResponseDataModel? data;

  LoginResponseModel({
    required this.statusCode,
    required this.success,
    required this.code,
    required this.message,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      statusCode: json['statusCode'] as int? ?? 0,
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      data: json['data'] == null
          ? null
          : LoginResponseDataModel.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            ),
    );
  }
}

class LoginResponseDataModel {
  final UserModel? user;
  final String? accessToken;
  final String? refreshToken;

  LoginResponseDataModel({
    this.user,
    this.accessToken,
    this.refreshToken,
  });

  factory LoginResponseDataModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseDataModel(
      user: json['user'] == null
          ? null
          : UserModel.fromJson(Map<String, dynamic>.from(json['user'] as Map)),
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );
  }
}

class UserModel {
  final String? id;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? profileImage;
  final String? authProvider;
  final String? role;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final List<String> fcmTokens;
  final bool isProtected;

  UserModel({
    this.id,
    this.fullName,
    this.email,
    this.phone,
    this.profileImage,
    this.authProvider,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.fcmTokens = const [],
    this.isProtected = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      profileImage: json['profileImage'] as String?,
      authProvider: json['authProvider'] as String?,
      role: json['role'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
      fcmTokens: (json['fcmTokens'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      isProtected: json['isProtected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'authProvider': authProvider,
      'role': role,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'fcmTokens': fcmTokens,
      'isProtected': isProtected,
    };
  }
}
