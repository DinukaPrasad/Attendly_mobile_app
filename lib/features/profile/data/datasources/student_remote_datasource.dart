import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../core/errors/exceptions.dart';
import '../models/student_model.dart';

/// Remote data source for student operations.
///
/// This handles HTTP communication with the student API.
abstract class StudentRemoteDataSource {
  /// Fetches all students from the API.
  /// Throws [NetworkException] on connection errors.
  /// Throws [ServerException] on server errors.
  Future<List<StudentModel>> fetchAllStudents();

  /// Fetches a student by ID.
  /// Throws [NetworkException] on connection errors.
  /// Throws [ServerException] on server errors.
  Future<StudentModel> fetchStudentById(String id);
}

/// Implementation of [StudentRemoteDataSource].
class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  final http.Client _client;
  final String _baseUrl;

  StudentRemoteDataSourceImpl({
    http.Client? client,
    String baseUrl = 'http://10.93.142.198:8080/api/students',
  }) : _client = client ?? http.Client(),
       _baseUrl = baseUrl;

  @override
  Future<List<StudentModel>> fetchAllStudents() async {
    try {
      final uri = Uri.parse(_baseUrl);
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

      // Handle both list and object responses
      if (json is List) {
        return StudentModel.fromJsonList(json);
      } else if (json is Map && json.containsKey('data')) {
        return StudentModel.fromJsonList(json['data'] as List<dynamic>);
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
  Future<StudentModel> fetchStudentById(String id) async {
    try {
      final uri = Uri.parse('$_baseUrl/$id');
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
      return StudentModel.fromJson(json);
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
