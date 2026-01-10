import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../errors/exceptions.dart';

/// HTTP client wrapper with JWT authentication support.
/// 
/// Features:
/// - Automatic JWT token injection
/// - Request/response logging (debug mode)
/// - Error mapping to AppExceptions
/// - Timeout handling
abstract class ApiClient {
  Future<Map<String, dynamic>> get(String endpoint);
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body);
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body);
  Future<Map<String, dynamic>> delete(String endpoint);
  
  /// Sets the auth token for subsequent requests
  void setAuthToken(String? token);
}

/// Implementation of ApiClient using http package
class ApiClientImpl implements ApiClient {
  final http.Client _client;
  final String _baseUrl;
  String? _authToken;

  ApiClientImpl({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? ApiConstants.baseUrl;

  @override
  void setAuthToken(String? token) {
    _authToken = token;
  }

  Map<String, String> get _headers => {
        'Content-Type': ApiConstants.contentType,
        'Accept': ApiConstants.contentType,
        if (_authToken != null)
          ApiConstants.authorization: '${ApiConstants.bearer} $_authToken',
      };

  @override
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await _client
          .get(
            Uri.parse('$_baseUrl${ApiConstants.apiVersion}$endpoint'),
            headers: _headers,
          )
          .timeout(ApiConstants.connectionTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException(
        message: 'No internet connection',
        code: 'no-internet',
      );
    } on http.ClientException catch (e) {
      throw NetworkException(
        message: 'Network request failed',
        originalError: e,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl${ApiConstants.apiVersion}$endpoint'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(ApiConstants.connectionTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException(
        message: 'No internet connection',
        code: 'no-internet',
      );
    } on http.ClientException catch (e) {
      throw NetworkException(
        message: 'Network request failed',
        originalError: e,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _client
          .put(
            Uri.parse('$_baseUrl${ApiConstants.apiVersion}$endpoint'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(ApiConstants.connectionTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException(
        message: 'No internet connection',
        code: 'no-internet',
      );
    } on http.ClientException catch (e) {
      throw NetworkException(
        message: 'Network request failed',
        originalError: e,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await _client
          .delete(
            Uri.parse('$_baseUrl${ApiConstants.apiVersion}$endpoint'),
            headers: _headers,
          )
          .timeout(ApiConstants.connectionTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException(
        message: 'No internet connection',
        code: 'no-internet',
      );
    } on http.ClientException catch (e) {
      throw NetworkException(
        message: 'Network request failed',
        originalError: e,
      );
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = response.body.isNotEmpty
        ? jsonDecode(response.body) as Map<String, dynamic>
        : <String, dynamic>{};

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    final message = body['message'] as String? ??
        body['error'] as String? ??
        'Request failed';

    if (response.statusCode == 401) {
      throw AuthException(
        message: message,
        code: 'unauthorized',
      );
    }

    if (response.statusCode == 403) {
      throw AuthException(
        message: message,
        code: 'forbidden',
      );
    }

    if (response.statusCode == 404) {
      throw ServerException(
        message: message,
        code: 'not-found',
        statusCode: 404,
      );
    }

    if (response.statusCode >= 500) {
      throw ServerException(
        message: 'Server error. Please try again later.',
        code: 'server-error',
        statusCode: response.statusCode,
      );
    }

    throw ServerException(
      message: message,
      statusCode: response.statusCode,
    );
  }
}
