import 'package:travel_app/core/helper/app_validation/validation.dart';

class ValidationMessageMapper {
  ValidationMessageMapper._();

  static String? mapEmail(EmailValidationResult? result) {
    switch (result) {
      case EmailValidationResult.empty:
        return 'Email required';
      case EmailValidationResult.invalid:
        return 'Email invalid';
      case null:
        return null;
    }
  }

  static String? mapPassword(PasswordValidationResult? result) {
    switch (result) {
      case PasswordValidationResult.empty:
        return 'Password required';
      case PasswordValidationResult.short:
        return 'Password short';
      case PasswordValidationResult.noLowercase:
        return 'Password no lowercase';
      case PasswordValidationResult.noUppercase:
        return 'Password no uppercase';
      case PasswordValidationResult.noNumber:
        return 'Password no number';
      case PasswordValidationResult.noSpecialCharacter:
        return 'Password no special character';
      case null:
        return null;
    }
  }

  static String? mapName(NameValidationResult? result) {
    switch (result) {
      case NameValidationResult.empty:
        return 'Name required';
      case NameValidationResult.tooShort:
        return 'Name too short';
      case null:
        return null;
    }
  }

  static String? mapPhone(PhoneValidationResult? result) {
    switch (result) {
      case PhoneValidationResult.empty:
        return 'Phone required';
      case PhoneValidationResult.invalid:
        return 'Phone invalid';
      case null:
        return null;
    }
  }

  static String? mapConfirmPassword(ConfirmPasswordValidationResult? result) {
    switch (result) {
      case ConfirmPasswordValidationResult.empty:
        return 'Confirm password required';
      case ConfirmPasswordValidationResult.notMatch:
        return 'Confirm password not match';
      case null:
        return null;
    }
  }

  static String? validateEmail(String? value) =>
      mapEmail(AppValidator.emailValidation(value));

  static String? validatePassword(String? value) =>
      mapPassword(AppValidator.passwordValidation(value));

  static String? validateName(String? value) =>
      mapName(AppValidator.nameValidation(value));

  static String? validatePhone(String? value) =>
      mapPhone(AppValidator.phoneValidation(value));

  static String? validateConfirmPassword({
    String? password,
    String? confirmPassword,
  }) => mapConfirmPassword(
    AppValidator.confirmPasswordValidation(
      password: password,
      confirmPassword: confirmPassword,
    ),
  );
}
