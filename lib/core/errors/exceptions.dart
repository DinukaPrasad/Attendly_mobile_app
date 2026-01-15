/// Base class for all exceptions in the data layer.
///
/// Exceptions are thrown in the data layer and caught/mapped to Failures
/// in the repository implementations.
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException({required this.message, this.code, this.originalError});

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Thrown when a network request fails
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Network request failed',
    super.code,
    super.originalError,
  });
}

/// Thrown when the server returns an error
class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    required super.message,
    super.code,
    super.originalError,
    this.statusCode,
  });
}

/// Thrown for authentication errors
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// Thrown for cache/storage errors
class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache operation failed',
    super.code,
    super.originalError,
  });
}

/// Thrown for validation errors in data layer
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.originalError,
  });
}
