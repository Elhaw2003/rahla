import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/core/helper/app_validation/validation.dart';
import 'package:travel_app/core/helper/app_validation/validation_message_mapper.dart';

void main() {
  group('AppValidator', () {
    test('email: empty and invalid values', () {
      expect(AppValidator.emailValidation(null), EmailValidationResult.empty);
      expect(
        AppValidator.emailValidation('not-an-email'),
        EmailValidationResult.invalid,
      );
    });

    test('email: valid value', () {
      expect(AppValidator.emailValidation('user@example.com'), isNull);
    });

    test('password: returns each validation error', () {
      expect(
        AppValidator.passwordValidation(null),
        PasswordValidationResult.empty,
      );
      expect(
        AppValidator.passwordValidation('Short1!'),
        PasswordValidationResult.short,
      );
      expect(
        AppValidator.passwordValidation('lowercase1!'),
        PasswordValidationResult.noUppercase,
      );
      expect(
        AppValidator.passwordValidation('UPPERCASE1!'),
        PasswordValidationResult.noLowercase,
      );
      expect(
        AppValidator.passwordValidation('NoNumbers!'),
        PasswordValidationResult.noNumber,
      );
      expect(
        AppValidator.passwordValidation('Valid123A'),
        PasswordValidationResult.noSpecialCharacter,
      );
    });

    test('password: valid value', () {
      expect(AppValidator.passwordValidation('Valid123!'), isNull);
    });

    test('name: empty and too short', () {
      expect(AppValidator.nameValidation('   '), NameValidationResult.empty);
      expect(AppValidator.nameValidation('Al'), NameValidationResult.tooShort);
      expect(AppValidator.nameValidation('Ali'), isNull);
    });

    test('phone: empty and invalid Egyptian phone', () {
      expect(AppValidator.phoneValidation(''), PhoneValidationResult.empty);
      expect(
        AppValidator.phoneValidation('123456789'),
        PhoneValidationResult.invalid,
      );
      expect(AppValidator.phoneValidation('01012345678'), isNull);
    });

    test('confirm password: empty and mismatch', () {
      expect(
        AppValidator.confirmPasswordValidation(
          password: 'Valid123!',
          confirmPassword: '',
        ),
        ConfirmPasswordValidationResult.empty,
      );
      expect(
        AppValidator.confirmPasswordValidation(
          password: 'Valid123!',
          confirmPassword: 'Different123!',
        ),
        ConfirmPasswordValidationResult.notMatch,
      );
      expect(
        AppValidator.confirmPasswordValidation(
          password: 'Valid123!',
          confirmPassword: 'Valid123!',
        ),
        isNull,
      );
    });
  });

  group('ValidationMessageMapper', () {
    test('maps validation results to messages', () {
      expect(ValidationMessageMapper.validateEmail(null), 'Email required');
      expect(ValidationMessageMapper.validateEmail('invalid'), 'Email invalid');
      expect(ValidationMessageMapper.validatePassword(''), 'Password required');
      expect(ValidationMessageMapper.validateName('Al'), 'Name too short');
      expect(ValidationMessageMapper.validatePhone('123'), 'Phone invalid');
      expect(
        ValidationMessageMapper.validateConfirmPassword(
          password: 'a',
          confirmPassword: 'b',
        ),
        'Confirm password not match',
      );
      expect(ValidationMessageMapper.validateEmail('user@example.com'), isNull);
    });
  });
}
