import 'package:equatable/equatable.dart';

/// Entity representing a student in the domain layer.
///
/// This is a pure Dart class with no external dependencies.
class Student extends Equatable {
  final String id;
  final String fullName;
  final String email;

  const Student({
    required this.id,
    required this.fullName,
    required this.email,
  });

  @override
  List<Object?> get props => [id, fullName, email];
}
