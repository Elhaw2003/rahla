import 'package:equatable/equatable.dart';
import 'package:travel_app/features/user/auth/data/models/login_response_model.dart';

class RegisterResponseModel extends Equatable {
  final int? statusCode;
  final bool? success;
  final String? code;
  final String? message;
  final UserResponseModel? user;
  final String? accessToken;
  final String? refreshToken;

  const RegisterResponseModel({
    this.statusCode,
    this.success,
    this.code,
    this.message,
    this.user,
    this.accessToken,
    this.refreshToken,
  });

  @override
  List<Object?> get props => [
    statusCode,
    success,
    code,
    message,
    user,
    accessToken,
    refreshToken,
  ];

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final dataMap = data is Map
        ? Map<String, dynamic>.from(data)
        : <String, dynamic>{};

    return RegisterResponseModel(
      statusCode: json['statusCode'] as int? ?? 0,
      success: json['success'] as bool? ?? false,
      code: json['code'] as String? ?? '',
      message: json['message'] as String? ?? '',
      user: dataMap['user'] is Map
          ? UserResponseModel.fromJson(
              Map<String, dynamic>.from(dataMap['user'] as Map),
            )
          : null,
      accessToken: dataMap['accessToken'] as String? ?? '',
      refreshToken: dataMap['refreshToken'] as String? ?? '',
    );
  }
}
