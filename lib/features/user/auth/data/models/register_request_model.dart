import 'package:equatable/equatable.dart';

class RegisterRequestModel extends Equatable {
  final String? fullName;
  final String? email;
  final String? phone;
  final String? password;
  final String? confirmPassword;
  final String? profileImage;
  final bool? isProtected;

  const RegisterRequestModel({
    this.fullName,
    this.email,
    this.phone,
    this.password,
    this.confirmPassword,
    this.profileImage,
    this.isProtected = false,
  });
  @override
  List<Object?> get props => [
    fullName,
    email,
    phone,
    password,
    confirmPassword,
    profileImage,
    isProtected,
  ];

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName ?? '',
      'email': email ?? '',
      'phone': phone ?? '',
      'password': password ?? '',
      'confirmPassword': confirmPassword ?? '',
      'isProtected': isProtected ?? false,
      if (profileImage != null && profileImage!.isNotEmpty)
        'profileImage': profileImage,
    };
  }
}
