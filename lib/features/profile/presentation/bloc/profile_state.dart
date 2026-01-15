import 'package:equatable/equatable.dart';

import '../../domain/entities/student.dart';
import '../../domain/entities/user.dart';

/// Status of profile operations
enum ProfileStatus { initial, loading, loaded, failure }

/// State for the Profile BLoC
final class ProfileState extends Equatable {
  final ProfileStatus status;
  final List<Student> students;
  final List<User> users;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.students = const [],
    this.users = const [],
    this.errorMessage,
  });

  /// Initial state
  const ProfileState.initial()
    : status = ProfileStatus.initial,
      students = const [],
      users = const [],
      errorMessage = null;

  /// Whether data is currently loading
  bool get isLoading => status == ProfileStatus.loading;

  /// Whether there is any data loaded
  bool get hasData => students.isNotEmpty || users.isNotEmpty;

  /// Creates a copy with optional new values
  ProfileState copyWith({
    ProfileStatus? status,
    List<Student>? students,
    List<User>? users,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      students: students ?? this.students,
      users: users ?? this.users,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, students, users, errorMessage];
}
