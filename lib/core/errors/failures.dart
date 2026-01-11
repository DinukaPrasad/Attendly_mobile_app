import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
///
/// Failures represent expected error conditions that should be handled gracefully.
/// Each failure type can carry a user-friendly message.
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Network-related failures (no internet, timeout, server errors)
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message =
        'Unable to connect. Please check your internet connection and try again.',
    super.code,
  });

  /// Factory for API unreachable errors
  factory NetworkFailure.apiUnreachable() => const NetworkFailure(
    message: 'Server is currently unavailable. Please try again later.',
    code: 'api-unreachable',
  );

  /// Factory for timeout errors
  factory NetworkFailure.timeout() => const NetworkFailure(
    message: 'Request timed out. Please check your connection and try again.',
    code: 'timeout',
  );

  /// Factory for no internet errors
  factory NetworkFailure.noInternet() => const NetworkFailure(
    message: 'No internet connection. Please check your network settings.',
    code: 'no-internet',
  );
}

/// Server returned an error response
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({required super.message, super.code, this.statusCode});

  @override
  List<Object?> get props => [message, code, statusCode];
}

/// Authentication failures (invalid credentials, expired token, etc.)
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});

  /// Common auth failure factory methods
  factory AuthFailure.invalidCredentials() => const AuthFailure(
    message: 'Invalid email or password',
    code: 'invalid-credential',
  );

  factory AuthFailure.userNotFound() => const AuthFailure(
    message: 'No account found with this email',
    code: 'user-not-found',
  );

  factory AuthFailure.wrongPassword() =>
      const AuthFailure(message: 'Incorrect password', code: 'wrong-password');

  factory AuthFailure.emailAlreadyInUse() => const AuthFailure(
    message: 'An account already exists with this email',
    code: 'email-already-in-use',
  );

  factory AuthFailure.weakPassword() =>
      const AuthFailure(message: 'Password is too weak', code: 'weak-password');

  factory AuthFailure.userDisabled() => const AuthFailure(
    message: 'This account has been disabled',
    code: 'user-disabled',
  );

  factory AuthFailure.tooManyRequests() => const AuthFailure(
    message: 'Too many attempts. Please try again later',
    code: 'too-many-requests',
  );

  factory AuthFailure.operationNotAllowed() => const AuthFailure(
    message: 'This sign-in method is not enabled',
    code: 'operation-not-allowed',
  );

  factory AuthFailure.cancelled() =>
      const AuthFailure(message: 'Sign-in was cancelled', code: 'cancelled');

  factory AuthFailure.expired() => const AuthFailure(
    message: 'Session expired. Please sign in again',
    code: 'session-expired',
  );
}

/// Input validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});

  factory ValidationFailure.emptyEmail() => const ValidationFailure(
    message: 'Please enter your email',
    code: 'empty-email',
  );

  factory ValidationFailure.invalidEmail() => const ValidationFailure(
    message: 'Please enter a valid email address',
    code: 'invalid-email',
  );

  factory ValidationFailure.emptyPassword() => const ValidationFailure(
    message: 'Please enter your password',
    code: 'empty-password',
  );

  factory ValidationFailure.passwordTooShort() => const ValidationFailure(
    message: 'Password must be at least 6 characters',
    code: 'password-too-short',
  );

  factory ValidationFailure.emptyField(String fieldName) => ValidationFailure(
    message: 'Please enter $fieldName',
    code: 'empty-field',
  );
}

/// Cache/storage failures
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to access local storage',
    super.code,
  });
}

/// Location/GPS failures
class LocationFailure extends Failure {
  const LocationFailure({required super.message, super.code});

  factory LocationFailure.permissionDenied() => const LocationFailure(
    message: 'Location permission denied',
    code: 'permission-denied',
  );

  factory LocationFailure.serviceDisabled() => const LocationFailure(
    message: 'Location services are disabled',
    code: 'service-disabled',
  );

  factory LocationFailure.timeout() => const LocationFailure(
    message: 'Failed to get location. Please try again',
    code: 'timeout',
  );
}

/// Unknown/unexpected failures
class UnknownFailure extends Failure {
  final dynamic originalError;

  const UnknownFailure({
    super.message = 'Something went wrong. Please try again',
    super.code,
    this.originalError,
  });

  @override
  List<Object?> get props => [message, code, originalError];
}
