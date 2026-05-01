import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import 'api_exception.dart' as exceptions;

/// Centralized HTTP client. All network calls go through this class.
///
/// Usage:
///   final client = ApiClient();
///   final data = await client.get('/api/some-endpoint');
///   final result = await client.post('/api/some-endpoint', body: {'key': 'value'});
///
/// With auth token:
///   client.setAuthToken(token);   // call after login
///   client.clearAuthToken();      // call on logout
class ApiClient {
  final http.Client _httpClient;
  String? _authToken;

  // Global token shared across all ApiClient instances, set once at login.
  static String? _globalAuthToken;

  static void setGlobalToken(String? token) => _globalAuthToken = token;

  ApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  // ─── Auth token ────────────────────────────────────────────────────────────

  void setAuthToken(String token) => _authToken = token;
  void clearAuthToken() => _authToken = null;

  // ─── Headers ───────────────────────────────────────────────────────────────

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_authToken != null || _globalAuthToken != null)
          'Authorization': 'Bearer ${_authToken ?? _globalAuthToken}',
      };

  // ─── HTTP Methods ──────────────────────────────────────────────────────────

  Future<dynamic> get(String endpoint) => _execute(
        () => _httpClient.get(
          _uri(endpoint),
          headers: _headers,
        ),
      );

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async =>
      (await _execute(
        () => _httpClient.post(
          _uri(endpoint),
          headers: _headers,
          body: jsonEncode(body),
        ),
      )) as Map<String, dynamic>;

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async =>
      (await _execute(
        () => _httpClient.put(
          _uri(endpoint),
          headers: _headers,
          body: jsonEncode(body),
        ),
      )) as Map<String, dynamic>;

  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async =>
      (await _execute(
        () => _httpClient.patch(
          _uri(endpoint),
          headers: _headers,
          body: jsonEncode(body),
        ),
      )) as Map<String, dynamic>;

  Future<Map<String, dynamic>> delete(String endpoint) async =>
      (await _execute(
        () => _httpClient.delete(
          _uri(endpoint),
          headers: _headers,
        ),
      )) as Map<String, dynamic>;

  // ─── Internals ─────────────────────────────────────────────────────────────

  Uri _uri(String endpoint) =>
      Uri.parse('${ApiConstants.baseUrl}$endpoint');

  Future<dynamic> _execute(Future<http.Response> Function() call) async {
    try {
      final response = await call().timeout(ApiConstants.timeout);
      return _handleResponse(response);
    } on exceptions.ApiException {
      rethrow;
    } on TimeoutException {
      throw const exceptions.TimeoutException();
    } catch (e) {
      throw exceptions.NetworkException('Network error: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return <String, dynamic>{};
      try {
        return jsonDecode(response.body);
      } catch (_) {
        return response.body; // plain text response (e.g. /api/health)
      }
    }

    String message = 'Something went wrong';
    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      message = json['message'] as String? ?? message;
    } catch (_) {
      if (response.body.isNotEmpty) message = response.body;
    }

    switch (response.statusCode) {
      case 401:
        throw exceptions.UnauthorizedException(message);
      case >= 500:
        throw exceptions.ServerException(message);
      default:
        throw exceptions.ApiException(message, statusCode: response.statusCode);
    }
  }
}
