class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  const NetworkException([super.message = 'Network error. Check your connection.']);
}

class TimeoutException extends ApiException {
  const TimeoutException([super.message = 'Request timed out.']);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException([super.message = 'Unauthorized. Please log in again.'])
      : super(statusCode: 401);
}

class ServerException extends ApiException {
  const ServerException([super.message = 'Server error. Try again later.'])
      : super(statusCode: 500);
}
