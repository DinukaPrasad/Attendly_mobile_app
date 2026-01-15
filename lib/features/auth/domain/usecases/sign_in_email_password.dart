import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Parameters for SignInEmailPassword use case
class SignInEmailPasswordParams extends Equatable {
  final String email;
  final String password;

  const SignInEmailPasswordParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Use case for signing in with email and password.
///
/// This encapsulates the business logic for email/password authentication.
/// It depends only on the abstract [AuthRepository], not on concrete implementations.
///
/// NOTE: This is pure Dart - no Flutter or Firebase imports allowed.
class SignInEmailPassword
    implements UseCase<AuthUser, SignInEmailPasswordParams> {
  final AuthRepository _repository;

  SignInEmailPassword(this._repository);

  /// Executes the sign-in operation.
  ///
  /// Returns [Result.success] with [AuthUser] on success.
  /// Returns [Result.failure] with appropriate [Failure] on error.
  @override
  Future<Result<AuthUser>> call(SignInEmailPasswordParams params) async {
    // Validate inputs before calling repository
    final emailError = _validateEmail(params.email);
    if (emailError != null) {
      return Result.failure(emailError);
    }

    final passwordError = _validatePassword(params.password);
    if (passwordError != null) {
      return Result.failure(passwordError);
    }

    return _repository.signInWithEmailPassword(
      email: params.email.trim(),
      password: params.password,
    );
  }

  /// Validates email format
  ValidationFailure? _validateEmail(String email) {
    if (email.trim().isEmpty) {
      return ValidationFailure.emptyEmail();
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(email.trim())) {
      return ValidationFailure.invalidEmail();
    }
    return null;
  }

  /// Validates password
  ValidationFailure? _validatePassword(String password) {
    if (password.isEmpty) {
      return ValidationFailure.emptyPassword();
    }
    return null;
  }
}
