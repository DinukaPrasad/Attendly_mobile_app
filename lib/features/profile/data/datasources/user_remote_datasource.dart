import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

/// Remote data source for user profile operations.
///
/// This handles HTTP communication with the user API.
abstract class UserRemoteDataSource {
  /// Fetches a list of users from the API.
  /// Throws [NetworkException] on connection errors.
  /// Throws [ServerException] on server errors.
  Future<List<UserModel>> fetchUsers({int count = 30});

  /// Fetches a single random user from the API.
  /// Throws [NetworkException] on connection errors.
  /// Throws [ServerException] on server errors.
  Future<UserModel> fetchRandomUser();
}

/// Implementation of [UserRemoteDataSource].
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client _client;
  final String _baseUrl;

  UserRemoteDataSourceImpl({
    http.Client? client,
    String baseUrl = 'https://randomuser.me/api',
  }) : _client = client ?? http.Client(),
       _baseUrl = baseUrl;

  @override
  Future<List<UserModel>> fetchUsers({int count = 30}) async {
    try {
      final uri = Uri.parse('$_baseUrl/?results=$count');
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
      final results = json['results'] as List<dynamic>;

      return UserModel.fromJsonList(results);
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
  Future<UserModel> fetchRandomUser() async {
    final users = await fetchUsers(count: 1);
    if (users.isEmpty) {
      throw const ServerException(message: 'No user data returned');
    }
    return users.first;
  }
}
