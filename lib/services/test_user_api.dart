import 'dart:convert';
import 'package:attendly/models/user.dart';
import 'package:attendly/models/user_name.dart';
import 'package:http/http.dart' as http;

class TestUserApi {
  static Future<List<User>> fetchUser() async {
    const url = 'https://randomuser.me/api/?results=20';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;

    final json = jsonDecode(body);
    final results = json['results'] as List<dynamic>;

    final users = results
        .map(
          (e) => User(
            gender: e['gender'],
            email: e['email'],
            phone: e['phone'],
            name: UserName(
              title: e['name']['title'],
              first: e['name']['first'],
              last: e['name']['last'],
            ),
          ),
        )
        .toList();
    return users;
  }
}
