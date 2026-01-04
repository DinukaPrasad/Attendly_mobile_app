import 'dart:convert';
import 'dart:io';
import 'package:attendly/models/user.dart';
import 'package:http/http.dart' as http;

class TestUserApi {
  static Future<List<User>> fetchUser() async {
    try {
      const url = 'https://randomuser.me/api/?results=30';
      final uri = Uri.parse(url);

      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      // 🔹 HTTP status validation
      if (response.statusCode != 200) {
        throw HttpException('Server error: ${response.statusCode}');
      }

      final json = jsonDecode(response.body);

      return User.fromJsonList(json['results']);
    }
    // 🔹 No Internet / Socket issue
    on SocketException {
      throw Exception('No internet connection');
    }
    // 🔹 Timeout
    on HttpException catch (e) {
      throw Exception(e.message);
    } on FormatException {
      throw Exception('Invalid response format');
    }
    // 🔹 Fallback
    catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
