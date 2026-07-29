class AppValidator {
  AppValidator._();

  /// Email Validation..........
  static EmailValidationResult? emailValidation(String? email) {
    if (email == null || email.isEmpty) {
      return EmailValidationResult.empty;
    }
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

    if (!emailRegExp.hasMatch(email)) {
      return EmailValidationResult.invalid;
    }
    return null;
  }

  /// Password Validation............
  static PasswordValidationResult? passwordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return PasswordValidationResult.empty;
    }

    if (value.length < 8) {
      return PasswordValidationResult.short;

      /// Password must be at least 8 characters long
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return PasswordValidationResult.noUppercase;

      /// Password must contain at least one uppercase letter
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return PasswordValidationResult.noLowercase;

      /// Password must contain at least one lowercase letter
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return PasswordValidationResult.noNumber;

      /// Password must contain at least one numeric character
    }
    if (!value.contains(RegExp(r'[!@#\$%^&*()<>?/|}{~:]'))) {
      return PasswordValidationResult.noSpecialCharacter;

      /// Password must contain at least one special character
    }

    return null;
  }

  static NameValidationResult? nameValidation(String? name) {
    if (name == null || name.trim().isEmpty) {
      return NameValidationResult.empty;
    }

    if (name.trim().length < 3) {
      return NameValidationResult.tooShort;
    }

    return null;
  }

  static PhoneValidationResult? phoneValidation(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return PhoneValidationResult.empty;
    }

    final phoneRegExp = RegExp(r'^01[0125][0-9]{8}$');

    if (!phoneRegExp.hasMatch(phone.trim())) {
      return PhoneValidationResult.invalid;
    }

    return null;
  }

  static ConfirmPasswordValidationResult? confirmPasswordValidation({
    String? password,
    String? confirmPassword,
  }) {
    if (confirmPassword == null || confirmPassword.trim().isEmpty) {
      return ConfirmPasswordValidationResult.empty;
    }

    if (password != confirmPassword) {
      return ConfirmPasswordValidationResult.notMatch;
    }

    return null;
  }
}

enum EmailValidationResult { empty, invalid }

enum PasswordValidationResult {
  empty,
  short,
  noUppercase,
  noLowercase,
  noNumber,
  noSpecialCharacter,
}

enum NameValidationResult { empty, tooShort }

enum PhoneValidationResult { empty, invalid }

enum ConfirmPasswordValidationResult { empty, notMatch }
