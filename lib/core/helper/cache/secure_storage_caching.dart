import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:travel_app/core/helper/cache/secure_storage_keys.dart';

class SecureStorageCaching {
  final FlutterSecureStorage _storage;

  SecureStorageCaching(this._storage);

  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read({required String key}) async {
    return _storage.read(key: key);
  }

  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<void> saveAccessToken(String token) async {
    await write(key: SecureStorageKeys.accessToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return read(key: SecureStorageKeys.accessToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await write(key: SecureStorageKeys.refreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return read(key: SecureStorageKeys.refreshToken);
  }

  Future<void> saveUser(Map<String, dynamic> user) async {
    await write(key: SecureStorageKeys.user, value: jsonEncode(user));
  }

  Future<Map<String, dynamic>?> getUser() async {
    final value = await read(key: SecureStorageKeys.user);
    if (value == null || value.isEmpty) return null;
    return jsonDecode(value) as Map<String, dynamic>;
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearAuthData() async {
    await delete(key: SecureStorageKeys.accessToken);
    await delete(key: SecureStorageKeys.refreshToken);
    await delete(key: SecureStorageKeys.user);
  }
}
