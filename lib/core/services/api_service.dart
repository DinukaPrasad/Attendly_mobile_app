import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/constants.dart';

class ApiService {
  // Singleton pattern (optional)
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<Map<String, String>> _buildHeaders() async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) {
      throw Exception('No authenticated user for API call');
    }

    return {
      'Content-Type': ApiConstants.contentType,
      ApiConstants.authorization: '${ApiConstants.bearer} $token',
    };
  }

  // Example: Get notifications
  Future<List<dynamic>> getNotifications() async {
    final headers = await _buildHeaders();
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiEndpoints.notifications}',
    );
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse['content'] ?? [];
    }
    throw Exception('Failed to load notifications');
  }

  // Example: Mark notification as read
  Future<void> markNotificationRead(String id, {bool read = true}) async {
    final headers = await _buildHeaders();
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiEndpoints.notifications}/$id/read-status?read=$read',
    );
    final response = await http.patch(url, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read');
    }
  }
}
