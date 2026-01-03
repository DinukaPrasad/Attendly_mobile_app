import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<void> writeToken(String token) {
    // TODO: encrypt and store token securely.
    return _storage.write(key: 'token', value: token);
  }
}
