import 'package:attendly/models/user_name.dart';

class User {
  final String gender;
  final String email;
  final String phone;
  final UserName name;

  const User({
    required this.gender,
    required this.email,
    required this.phone,
    required this.name,
  });

  String get fullName => '${name.title} ${name.first} ${name.last}';

  factory User.fromJson(Map<String, dynamic> json) => User(
    gender: json['gender'],
    email: json['email'],
    phone: json['phone'],
    name: UserName.fromJson(json['name']),
  );

  static List<User> fromJsonList(List<dynamic> jsonList) => jsonList
      .map((item) => User.fromJson(item as Map<String, dynamic>))
      .toList();
}
