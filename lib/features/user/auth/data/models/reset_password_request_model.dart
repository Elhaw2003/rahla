class ResetPasswordRequestModel {
  final String email;
  final String otp;
  final String newPassword;
  final String confirmNewPassword;
  final bool isProtected;

  const ResetPasswordRequestModel({
    required this.email,
    required this.otp,
    required this.newPassword,
    required this.confirmNewPassword,
    this.isProtected = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      'newPassword': newPassword,
      'confirmPassword': confirmNewPassword,
      'isProtected': isProtected,
    };
  }
}
