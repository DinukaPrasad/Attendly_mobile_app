import 'package:equatable/equatable.dart';

import 'user_name.dart';

/// Entity representing a user profile in the domain layer.
///
/// This is a pure Dart class with no external dependencies.
class User extends Equatable {
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

  /// Returns the full name including title
  String get fullName => name.fullName;

  /// Returns the display name (first + last)
  String get displayName => name.displayName;

  @override
  List<Object?> get props => [gender, email, phone, name];
}
