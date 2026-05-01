import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  StorageService._();

  static const _storage = FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  /// Saves JWT token securely
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Retrieves saved token
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Saves user data as JSON string
  static Future<void> saveUser(String userJson) async {
    await _storage.write(key: _userKey, value: userJson);
  }

  /// Retrieves saved user JSON
  static Future<String?> getUser() async {
    return await _storage.read(key: _userKey);
  }

  /// Clears all stored data (for logout)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
