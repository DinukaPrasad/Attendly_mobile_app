import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

/// Use case for signing out the current user.
///
/// This encapsulates the business logic for user logout.
/// It depends only on the abstract [AuthRepository], not on concrete implementations.
///
/// NOTE: This is pure Dart - no Flutter or Firebase imports allowed.
class SignOut implements UseCaseNoParams<void> {
  final AuthRepository _repository;

  SignOut(this._repository);

  /// Executes the sign-out operation.
  ///
  /// Returns [Result.success] on success.
  /// Returns [Result.failure] with appropriate [Failure] on error.
  @override
  Future<Result<void>> call() async {
    return _repository.signOut();
  }
}
