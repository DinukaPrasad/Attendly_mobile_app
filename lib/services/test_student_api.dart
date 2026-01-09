import 'dart:convert';
import 'dart:io';
import 'package:attendly/models/student.dart';
import 'package:http/http.dart' as http;

class TestStudentApi {
  static const String baseUrl = 'http://10.93.142.198:8080/api/students';

  /// Fetch all students
  static Future<List<Student>> fetchAllStudents() async {
    try {
      final uri = Uri.parse(baseUrl);

      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      // 🔹 HTTP status validation
      if (response.statusCode != 200) {
        throw HttpException('Server error: ${response.statusCode}');
      }

      final json = jsonDecode(response.body);

      // Handle both list and object responses
      if (json is List) {
        return Student.fromJsonList(json);
      } else if (json is Map && json.containsKey('data')) {
        return Student.fromJsonList(json['data'] as List<dynamic>);
      }

      return [];
    }
    // 🔹 No Internet / Socket issue
    on SocketException {
      throw Exception('No internet connection');
    }
    // 🔹 Timeout
    on HttpException catch (e) {
      throw Exception(e.message);
    }
    // 🔹 Format exception
    on FormatException {
      throw Exception('Invalid response format');
    }
    // 🔹 Fallback
    catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
