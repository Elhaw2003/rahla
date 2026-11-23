import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:travel_app/core/helper/cache/secure_storage_caching.dart';
import 'package:travel_app/core/helper/cache/secure_storage_keys.dart';

import 'secure_storage_caching_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FlutterSecureStorage>()])
void main() {
  late MockFlutterSecureStorage storage;
  late SecureStorageCaching caching;

  setUp(() {
    storage = MockFlutterSecureStorage();
    caching = SecureStorageCaching(storage);
  });

  group('basic storage operations', () {
    test('write stores key and value', () async {
      await caching.write(key: 'test_key', value: 'test_value');

      verify(storage.write(key: 'test_key', value: 'test_value')).called(1);
    });

    test('read returns the stored value', () async {
      when(storage.read(key: 'test_key')).thenAnswer((_) async => 'test_value');

      expect(await caching.read(key: 'test_key'), 'test_value');
      verify(storage.read(key: 'test_key')).called(1);
    });

    test('delete removes the requested key', () async {
      await caching.delete(key: 'test_key');

      verify(storage.delete(key: 'test_key')).called(1);
    });

    test('deleteAll removes all stored values', () async {
      await caching.deleteAll();

      verify(storage.deleteAll()).called(1);
    });
  });

  group('auth tokens', () {
    test('saveAccessToken uses the access-token key', () async {
      await caching.saveAccessToken('access-token');

      verify(
        storage.write(
          key: SecureStorageKeys.accessToken,
          value: 'access-token',
        ),
      ).called(1);
    });

    test('getAccessToken reads the access-token key', () async {
      when(
        storage.read(key: SecureStorageKeys.accessToken),
      ).thenAnswer((_) async => 'access-token');

      expect(await caching.getAccessToken(), 'access-token');
      verify(storage.read(key: SecureStorageKeys.accessToken)).called(1);
    });

    test('saveRefreshToken uses the refresh-token key', () async {
      await caching.saveRefreshToken('refresh-token');

      verify(
        storage.write(
          key: SecureStorageKeys.refreshToken,
          value: 'refresh-token',
        ),
      ).called(1);
    });

    test('getRefreshToken reads the refresh-token key', () async {
      when(
        storage.read(key: SecureStorageKeys.refreshToken),
      ).thenAnswer((_) async => 'refresh-token');

      expect(await caching.getRefreshToken(), 'refresh-token');
      verify(storage.read(key: SecureStorageKeys.refreshToken)).called(1);
    });
  });

  group('user data', () {
    test('saveUser encodes the user map as JSON', () async {
      await caching.saveUser({'id': '123', 'name': 'Ali'});

      verify(
        storage.write(
          key: SecureStorageKeys.user,
          value: '{"id":"123","name":"Ali"}',
        ),
      ).called(1);
    });

    test('getUser decodes a stored JSON object', () async {
      when(
        storage.read(key: SecureStorageKeys.user),
      ).thenAnswer((_) async => '{"id":"123","name":"Ali"}');

      expect(await caching.getUser(), {'id': '123', 'name': 'Ali'});
    });

    test('getUser returns null for missing or empty data', () async {
      when(
        storage.read(key: SecureStorageKeys.user),
      ).thenAnswer((_) async => null);
      expect(await caching.getUser(), isNull);

      when(
        storage.read(key: SecureStorageKeys.user),
      ).thenAnswer((_) async => '');
      expect(await caching.getUser(), isNull);
    });
  });

  group('login state', () {
    test('isLoggedIn returns true for a non-empty access token', () async {
      when(
        storage.read(key: SecureStorageKeys.accessToken),
      ).thenAnswer((_) async => 'access-token');

      expect(await caching.isLoggedIn(), isTrue);
    });

    test('isLoggedIn returns false for null or empty token', () async {
      when(
        storage.read(key: SecureStorageKeys.accessToken),
      ).thenAnswer((_) async => null);
      expect(await caching.isLoggedIn(), isFalse);

      when(
        storage.read(key: SecureStorageKeys.accessToken),
      ).thenAnswer((_) async => '');
      expect(await caching.isLoggedIn(), isFalse);
    });
  });

  group('clearAuthData', () {
    test('deletes access token, refresh token, and user', () async {
      await caching.clearAuthData();

      verify(storage.delete(key: SecureStorageKeys.accessToken)).called(1);
      verify(storage.delete(key: SecureStorageKeys.refreshToken)).called(1);
      verify(storage.delete(key: SecureStorageKeys.user)).called(1);
    });
  });
}
