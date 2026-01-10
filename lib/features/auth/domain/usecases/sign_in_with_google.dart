import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Use case for signing in with Google OAuth.
///
/// This encapsulates the business logic for Google authentication.
/// It depends only on the abstract [AuthRepository], not on concrete implementations.
///
/// NOTE: This is pure Dart - no Flutter or Firebase imports allowed.
class SignInWithGoogle implements UseCaseNoParams<AuthUser> {
  final AuthRepository _repository;

  SignInWithGoogle(this._repository);

  /// Executes the Google sign-in operation.
  ///
  /// Returns [Result.success] with [AuthUser] on success.
  /// Returns [Result.failure] if cancelled or on error.
  @override
  Future<Result<AuthUser>> call() async {
    return _repository.signInWithGoogle();
  }
}
