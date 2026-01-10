import 'package:equatable/equatable.dart';

/// Events for the Profile BLoC
sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Load all students
final class LoadStudents extends ProfileEvent {
  const LoadStudents();
}

/// Load all users
final class LoadUsers extends ProfileEvent {
  final int count;

  const LoadUsers({this.count = 30});

  @override
  List<Object?> get props => [count];
}

/// Load a random user
final class LoadRandomUser extends ProfileEvent {
  const LoadRandomUser();
}

/// Refresh the current data
final class RefreshProfile extends ProfileEvent {
  const RefreshProfile();
}
