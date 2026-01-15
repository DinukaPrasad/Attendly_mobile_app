// ignore_for_file: avoid_types_as_parameter_names

import '../utils/result.dart';

/// Base class for use cases with parameters.
///
/// Each use case should be a single responsibility - one action.
/// Use cases depend only on domain repositories (abstractions).
///
/// Example:
/// ```dart
/// class GetUser extends UseCase<User, GetUserParams> {
///   final UserRepository repository;
///   GetUser(this.repository);
///
///   @override
///   Future<Result<User>> call(GetUserParams params) {
///     return repository.getUser(params.userId);
///   }
/// }
/// ```
abstract class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

/// Use case with no parameters
abstract class UseCaseNoParams<T> {
  Future<Result<T>> call();
}

/// Placeholder for use cases that don't need parameters
class NoParams {
  const NoParams();
}
