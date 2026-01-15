import '../../domain/entities/student.dart';

/// Data model for Student with JSON serialization.
class StudentModel {
  final String id;
  final String fullName;
  final String email;

  const StudentModel({
    required this.id,
    required this.fullName,
    required this.email,
  });

  /// Creates a StudentModel from JSON
  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'fullName': fullName, 'email': email};
  }

  /// Converts to domain entity
  Student toEntity() {
    return Student(id: id, fullName: fullName, email: email);
  }

  /// Creates from domain entity
  factory StudentModel.fromEntity(Student entity) {
    return StudentModel(
      id: entity.id,
      fullName: entity.fullName,
      email: entity.email,
    );
  }

  /// Converts a list of JSON to list of StudentModel
  static List<StudentModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => StudentModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
