class UpdateProfileRequestModel {
  final String? fullName;
  final String? phone;
  final String? profileImage;

  const UpdateProfileRequestModel({
    this.fullName,
    this.phone,
    this.profileImage,
  });

  bool get hasChanges =>
      fullName != null ||
      phone != null ||
      (profileImage != null && profileImage!.isNotEmpty);
}
