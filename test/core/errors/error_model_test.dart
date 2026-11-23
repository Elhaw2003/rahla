import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/core/errors/error_model.dart';
import 'package:travel_app/core/errors/dio_exceptions.dart';

void main() {
  group('ErrorModel', () {
    test('fromJson uses message and extracts field errors', () {
      final model = ErrorModel.fromJson({
        'statusCode': 422,
        'message': 'Validation failed',
        'code': 'VALIDATION',
        'errors': {
          'email': ['Email is invalid'],
          'name': 'Name is required',
        },
      });

      expect(model.statusCode, 422);
      expect(model.message, 'Validation failed');
      expect(model.code, 'VALIDATION');
      expect(model.generalErrors, ['Email is invalid', 'Name is required']);
      expect(model.fieldErrors['email'], ['Email is invalid']);
      expect(model.fieldErrors['name'], ['Name is required']);
      expect(model.errorMessage, 'Email is invalid');
    });

    test('fromJson falls back to list errors and title', () {
      final model = ErrorModel.fromJson({
        'status': 404,
        'title': 'Not found',
        'errors': ['Missing resource'],
      });

      expect(model.statusCode, 404);
      expect(model.message, 'Not found');
      expect(model.generalErrors, ['Missing resource']);
      expect(model.errorMessage, 'Missing resource');
    });

    test('fromJson handles empty errors', () {
      final model = ErrorModel.fromJson({'statusCode': 500, 'message': ' '});

      expect(model.message, 'An error occurred');
      expect(model.errorMessage, 'An error occurred');
    });
  });

  group('Dio error parsing', () {
    test('parseErrorResponse handles null and string data', () {
      final nullModel = parseErrorResponse(null, 400);
      expect(nullModel.statusCode, 400);
      expect(nullModel.message, 'Bad request.');

      final stringModel = parseErrorResponse('Server unavailable', 503);
      expect(stringModel.message, 'Server unavailable');
      expect(stringModel.generalErrors, ['Server unavailable']);
    });

    test('parseErrorResponse handles maps and unknown data', () {
      final mapModel = parseErrorResponse({
        'statusCode': 401,
        'message': 'Unauthorized',
      }, 401);
      expect(mapModel.statusCode, 401);
      expect(mapModel.message, 'Unauthorized');

      final unknownModel = parseErrorResponse(123, 429);
      expect(unknownModel.message, 'Too many requests.');
    });

    test('getDefaultErrorMessage maps status codes', () {
      expect(getDefaultErrorMessage(400), 'Bad request.');
      expect(getDefaultErrorMessage(401), 'Unauthorized');
      expect(getDefaultErrorMessage(403), 'Access forbidden.');
      expect(getDefaultErrorMessage(404), 'Resource not found.');
      expect(getDefaultErrorMessage(409), 'Conflict occurred.');
      expect(getDefaultErrorMessage(422), 'Validation failed.');
      expect(getDefaultErrorMessage(429), 'Too many requests.');
      expect(getDefaultErrorMessage(500), 'Internal server error.');
      expect(getDefaultErrorMessage(504), 'Server timeout.');
      expect(getDefaultErrorMessage(418), 'Something went wrong.');
    });
  });
}
