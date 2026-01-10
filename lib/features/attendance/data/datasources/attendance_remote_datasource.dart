import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../core/errors/exceptions.dart';
import '../models/attendance_model.dart';
import '../models/attendance_session_model.dart';

/// Remote data source for attendance operations.
///
/// This handles HTTP communication with the attendance API.
abstract class AttendanceRemoteDataSource {
  /// Fetches all attendance records for a user.
  Future<List<AttendanceModel>> getAttendanceHistory(String userId);

  /// Fetches a specific attendance session by ID.
  Future<AttendanceSessionModel> getSessionById(String sessionId);

  /// Fetches active sessions available for check-in.
  Future<List<AttendanceSessionModel>> getActiveSessions();

  /// Submits attendance for a session.
  Future<AttendanceModel> submitAttendance({
    required String sessionId,
    required String userId,
    required String qrCode,
    double? latitude,
    double? longitude,
  });

  /// Validates a QR code and returns the session.
  Future<AttendanceSessionModel> validateQrCode(String qrCode);
}

/// Implementation of [AttendanceRemoteDataSource].
class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final http.Client _client;
  final String _baseUrl;

  AttendanceRemoteDataSourceImpl({
    http.Client? client,
    String baseUrl = 'http://10.93.142.198:8080/api/attendance',
  }) : _client = client ?? http.Client(),
       _baseUrl = baseUrl;

  @override
  Future<List<AttendanceModel>> getAttendanceHistory(String userId) async {
    try {
      final uri = Uri.parse('$_baseUrl/history/$userId');
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Server error: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }

      final json = jsonDecode(response.body);

      if (json is List) {
        return AttendanceModel.fromJsonList(json);
      } else if (json is Map && json.containsKey('data')) {
        return AttendanceModel.fromJsonList(json['data'] as List<dynamic>);
      }

      return [];
    } on SocketException {
      throw const NetworkException(message: 'No internet connection');
    } on HttpException catch (e) {
      throw ServerException(message: e.message);
    } on FormatException {
      throw const ServerException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<AttendanceSessionModel> getSessionById(String sessionId) async {
    try {
      final uri = Uri.parse('$_baseUrl/sessions/$sessionId');
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Server error: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AttendanceSessionModel.fromJson(json);
    } on SocketException {
      throw const NetworkException(message: 'No internet connection');
    } on HttpException catch (e) {
      throw ServerException(message: e.message);
    } on FormatException {
      throw const ServerException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<List<AttendanceSessionModel>> getActiveSessions() async {
    try {
      final uri = Uri.parse('$_baseUrl/sessions/active');
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Server error: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }

      final json = jsonDecode(response.body);

      if (json is List) {
        return AttendanceSessionModel.fromJsonList(json);
      } else if (json is Map && json.containsKey('data')) {
        return AttendanceSessionModel.fromJsonList(
          json['data'] as List<dynamic>,
        );
      }

      return [];
    } on SocketException {
      throw const NetworkException(message: 'No internet connection');
    } on HttpException catch (e) {
      throw ServerException(message: e.message);
    } on FormatException {
      throw const ServerException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<AttendanceModel> submitAttendance({
    required String sessionId,
    required String userId,
    required String qrCode,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/submit');
      final body = jsonEncode({
        'session_id': sessionId,
        'user_id': userId,
        'qr_code': qrCode,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _client
          .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          message: 'Server error: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AttendanceModel.fromJson(json);
    } on SocketException {
      throw const NetworkException(message: 'No internet connection');
    } on HttpException catch (e) {
      throw ServerException(message: e.message);
    } on FormatException {
      throw const ServerException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<AttendanceSessionModel> validateQrCode(String qrCode) async {
    try {
      final uri = Uri.parse('$_baseUrl/validate-qr');
      final body = jsonEncode({'qr_code': qrCode});

      final response = await _client
          .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Invalid or expired QR code',
          statusCode: response.statusCode,
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AttendanceSessionModel.fromJson(json);
    } on SocketException {
      throw const NetworkException(message: 'No internet connection');
    } on HttpException catch (e) {
      throw ServerException(message: e.message);
    } on FormatException {
      throw const ServerException(message: 'Invalid response format');
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(message: 'Unexpected error: $e');
    }
  }
}
