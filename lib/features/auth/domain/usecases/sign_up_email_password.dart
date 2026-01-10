import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Parameters for the SignUpEmailPassword use case
class SignUpParams {
  final String email;
  final String password;

  const SignUpParams({required this.email, required this.password});
}

/// Use case for registering a new user with email and password.
///
/// This validates the input before calling the repository.
class SignUpEmailPassword implements UseCase<AuthUser, SignUpParams> {
  final AuthRepository _repository;

  SignUpEmailPassword(this._repository);

  @override
  Future<Result<AuthUser>> call(SignUpParams params) async {
    // Validate email format
    if (params.email.isEmpty) {
      return Result.failure(ValidationFailure.emptyEmail());
    }

    if (!_isValidEmail(params.email)) {
      return Result.failure(ValidationFailure.invalidEmail());
    }

    // Validate password
    if (params.password.isEmpty) {
      return Result.failure(ValidationFailure.emptyPassword());
    }

    if (params.password.length < 6) {
      return Result.failure(ValidationFailure.passwordTooShort());
    }

    // Call the repository
    return _repository.registerWithEmailPassword(
      email: params.email.trim(),
      password: params.password,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }
}
