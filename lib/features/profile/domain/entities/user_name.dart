import 'package:equatable/equatable.dart';

/// Value object representing a user's name with title, first, and last components.
///
/// This is a pure Dart class with no external dependencies.
class UserName extends Equatable {
  final String title;
  final String first;
  final String last;

  const UserName({
    required this.title,
    required this.first,
    required this.last,
  });

  /// Returns the full name as a formatted string
  String get fullName => '$title $first $last'.trim();

  /// Returns first and last name only (no title)
  String get displayName => '$first $last'.trim();

  @override
  List<Object?> get props => [title, first, last];
}
