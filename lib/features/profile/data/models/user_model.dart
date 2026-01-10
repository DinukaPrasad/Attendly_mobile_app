import '../../domain/entities/user.dart';
import 'user_name_model.dart';

/// Data model for User with JSON serialization.
class UserModel {
  final String gender;
  final String email;
  final String phone;
  final UserNameModel name;

  const UserModel({
    required this.gender,
    required this.email,
    required this.phone,
    required this.name,
  });

  /// Creates a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      gender: json['gender'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      name: UserNameModel.fromJson(json['name'] as Map<String, dynamic>),
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'email': email,
      'phone': phone,
      'name': name.toJson(),
    };
  }

  /// Converts to domain entity
  User toEntity() {
    return User(
      gender: gender,
      email: email,
      phone: phone,
      name: name.toEntity(),
    );
  }

  /// Creates from domain entity
  factory UserModel.fromEntity(User entity) {
    return UserModel(
      gender: entity.gender,
      email: entity.email,
      phone: entity.phone,
      name: UserNameModel.fromEntity(entity.name),
    );
  }

  /// Converts a list of JSON to list of UserModel
  static List<UserModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
