import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Keys for secure storage
class SecureStorageKeys {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String biometricEnabled = 'biometric_enabled';

  SecureStorageKeys._();
}

/// Service for securely storing sensitive data like tokens and secrets.
///
/// Uses flutter_secure_storage which encrypts data on device.
/// NEVER store non-sensitive data here - use Isar instead.
abstract class SecureStorageService {
  Future<void> saveAccessToken(String token);
  Future<String?> getAccessToken();
  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> saveUserId(String userId);
  Future<String?> getUserId();
  Future<void> setBiometricEnabled(bool enabled);
  Future<bool> isBiometricEnabled();
  Future<void> clearAll();
  Future<void> clearTokens();
}

/// Implementation of [SecureStorageService] using flutter_secure_storage.
class SecureStorageServiceImpl implements SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageServiceImpl({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );

  @override
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: SecureStorageKeys.accessToken, value: token);
  }

  @override
  Future<String?> getAccessToken() async {
    return _storage.read(key: SecureStorageKeys.accessToken);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: SecureStorageKeys.refreshToken, value: token);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _storage.read(key: SecureStorageKeys.refreshToken);
  }

  @override
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: SecureStorageKeys.userId, value: userId);
  }

  @override
  Future<String?> getUserId() async {
    return _storage.read(key: SecureStorageKeys.userId);
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(
      key: SecureStorageKeys.biometricEnabled,
      value: enabled.toString(),
    );
  }

  @override
  Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: SecureStorageKeys.biometricEnabled);
    return value == 'true';
  }

  @override
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  @override
  Future<void> clearTokens() async {
    await _storage.delete(key: SecureStorageKeys.accessToken);
    await _storage.delete(key: SecureStorageKeys.refreshToken);
  }
}
