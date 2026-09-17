class ForgotPasswordRequestModel {
  final String email;
  final bool isProtected;

  const ForgotPasswordRequestModel({
    required this.email,
    this.isProtected = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'isProtected': isProtected,
    };
  }
}
