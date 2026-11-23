import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/core/errors/exceptions.dart';
import 'package:travel_app/core/errors/failure.dart';
import 'package:travel_app/core/errors/failure_mapper.dart';

void main() {
  group('mapExceptionToFailure', () {
    test('maps authentication exceptions', () {
      final failure = mapExceptionToFailure(
        AuthException('Unauthorized', 'AUTH', {
          'email': ['Invalid email'],
        }),
      );

      expect(failure, isA<AuthFailure>());
      expect(failure.message, 'Unauthorized');
      expect(failure.code, 'AUTH');
      expect(failure.fieldErrors, {
        'email': ['Invalid email'],
      });
    });

    test('maps every known exception family', () {
      expect(
        mapExceptionToFailure(NetworkException('Network')),
        isA<NetworkFailure>(),
      );
      expect(
        mapExceptionToFailure(ValidationException('Invalid')),
        isA<ValidationFailure>(),
      );
      expect(
        mapExceptionToFailure(PermissionException('Forbidden')),
        isA<PermissionFailure>(),
      );
      expect(
        mapExceptionToFailure(CacheException('Cache')),
        isA<CacheFailure>(),
      );
      expect(
        mapExceptionToFailure(StorageException('Storage')),
        isA<StorageFailure>(),
      );
      expect(
        mapExceptionToFailure(LocationException('Location')),
        isA<LocationFailure>(),
      );
      expect(
        mapExceptionToFailure(NotFoundException('Missing')),
        isA<NotFoundFailure>(),
      );
      expect(
        mapExceptionToFailure(ServerException('Server')),
        isA<ServerFailure>(),
      );
    });

    test('uses UnexpectedFailure for unknown base exceptions', () {
      final failure = mapExceptionToFailure(AppException('Unknown', 'UNKNOWN'));

      expect(failure, isA<UnexpectedFailure>());
      expect(failure.message, 'Unknown');
      expect(failure.code, 'UNKNOWN');
    });

    test('failure equality uses message, code, and field errors', () {
      const first = AuthFailure(
        'Unauthorized',
        code: 'AUTH',
        fieldErrors: {
          'email': ['Invalid'],
        },
      );
      const second = AuthFailure(
        'Unauthorized',
        code: 'AUTH',
        fieldErrors: {
          'email': ['Invalid'],
        },
      );

      expect(first, second);
    });
  });
}
