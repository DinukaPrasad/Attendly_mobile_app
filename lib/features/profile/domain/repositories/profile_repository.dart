import '../../../../core/utils/result.dart';
import '../entities/student.dart';
import '../entities/user.dart';

/// Abstract repository interface for profile operations.
///
/// This defines the contract that the data layer must implement.
/// The domain layer (use cases) depends only on this abstraction.
///
/// NOTE: This is pure Dart - no Flutter or HTTP imports allowed.
abstract class ProfileRepository {
  /// Fetches all students.
  ///
  /// Returns [Result.success] with list of [Student] on success.
  /// Returns [Result.failure] with appropriate [Failure] on error.
  Future<Result<List<Student>>> getAllStudents();

  /// Fetches a student by ID.
  ///
  /// Returns [Result.success] with [Student] on success.
  /// Returns [Result.failure] with appropriate [Failure] on error.
  Future<Result<Student>> getStudentById(String id);

  /// Fetches a list of users.
  ///
  /// Returns [Result.success] with list of [User] on success.
  /// Returns [Result.failure] with appropriate [Failure] on error.
  Future<Result<List<User>>> getUsers({int count = 30});

  /// Fetches a single random user profile.
  ///
  /// Returns [Result.success] with [User] on success.
  /// Returns [Result.failure] with appropriate [Failure] on error.
  Future<Result<User>> getRandomUser();
}
