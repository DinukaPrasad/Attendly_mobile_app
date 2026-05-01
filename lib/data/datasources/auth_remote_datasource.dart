import 'dart:convert';

import '../models/user_model.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      body: {'email': email, 'password': password},
    );
    // Backend returns {token, message, role} — not wrapped in ApiResponse.
    // Decode JWT payload to extract userId, name, and email (sub claim).
    final token = response['token'] as String?;
    if (token != null) {
      ApiClient.setGlobalToken(token);
      final claims = _decodeJwtPayload(token);
      return UserModel(
        id: claims['userId']?.toString() ?? '',
        name: claims['name'] as String? ?? '',
        email: claims['sub'] as String? ?? email,
        token: token,
        role: (response['role'] as String?) ?? claims['role'] as String?,
      );
    }
    return UserModel.fromJson(response);
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.register,
      body: {
        'name': name,
        'email': email,
        'password': password,
        'role': 'STUDENT',
      },
    );
    // Backend returns ApiResponse<UserResponse> — extract the nested data.
    final data = response['data'] as Map<String, dynamic>? ?? response;
    return UserModel.fromJson(data);
  }

  // Decodes the payload segment of a JWT without verifying the signature.
  Map<String, dynamic> _decodeJwtPayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return {};
      var payload = parts[1];
      while (payload.length % 4 != 0) {
        payload += '=';
      }
      final decoded = utf8.decode(base64Url.decode(payload));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }
}
