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
}
