import '../../domain/entities/user_name.dart';

/// Data model for UserName with JSON serialization.
class UserNameModel {
  final String title;
  final String first;
  final String last;

  const UserNameModel({
    required this.title,
    required this.first,
    required this.last,
  });

  /// Creates a UserNameModel from JSON
  factory UserNameModel.fromJson(Map<String, dynamic> json) {
    return UserNameModel(
      title: json['title'] as String? ?? '',
      first: json['first'] as String? ?? '',
      last: json['last'] as String? ?? '',
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {'title': title, 'first': first, 'last': last};
  }

  /// Converts to domain entity
  UserName toEntity() {
    return UserName(title: title, first: first, last: last);
  }

  /// Creates from domain entity
  factory UserNameModel.fromEntity(UserName entity) {
    return UserNameModel(
      title: entity.title,
      first: entity.first,
      last: entity.last,
    );
  }
}
