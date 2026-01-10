import 'package:attendly/core/errors/failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failures', () {
    group('NetworkFailure', () {
      test('should have correct message', () {
        const failure = NetworkFailure(message: 'No internet connection');

        expect(failure.message, 'No internet connection');
      });

      test('should have default message', () {
        const failure = NetworkFailure();

        expect(failure.message, 'A network error occurred');
      });

      test('should be equatable', () {
        const failure1 = NetworkFailure(message: 'Error');
        const failure2 = NetworkFailure(message: 'Error');

        expect(failure1, equals(failure2));
      });
    });

    group('ServerFailure', () {
      test('should include status code', () {
        const failure = ServerFailure(
          message: 'Internal server error',
          statusCode: 500,
        );

        expect(failure.message, 'Internal server error');
        expect(failure.statusCode, 500);
      });

      test('should have default message', () {
        const failure = ServerFailure();

        expect(failure.message, 'A server error occurred');
      });
    });

    group('CacheFailure', () {
      test('should have correct message', () {
        const failure = CacheFailure(message: 'Failed to read cache');

        expect(failure.message, 'Failed to read cache');
      });

      test('should have default message', () {
        const failure = CacheFailure();

        expect(failure.message, 'A cache error occurred');
      });
    });

    group('AuthFailure', () {
      test('should include code', () {
        const failure = AuthFailure(
          message: 'Invalid credentials',
          code: 'invalid-credentials',
        );

        expect(failure.message, 'Invalid credentials');
        expect(failure.code, 'invalid-credentials');
      });

      test('should have default message', () {
        const failure = AuthFailure();

        expect(failure.message, 'An authentication error occurred');
      });
    });

    group('ValidationFailure', () {
      test('should include field errors', () {
        final failure = ValidationFailure(
          message: 'Validation failed',
          fieldErrors: {'email': 'Invalid email', 'password': 'Too short'},
        );

        expect(failure.message, 'Validation failed');
        expect(failure.fieldErrors['email'], 'Invalid email');
        expect(failure.fieldErrors['password'], 'Too short');
      });

      test('should have empty field errors by default', () {
        const failure = ValidationFailure();

        expect(failure.fieldErrors, isEmpty);
      });
    });

    group('UnknownFailure', () {
      test('should wrap original error', () {
        final originalError = Exception('Something went wrong');
        final failure = UnknownFailure(originalError: originalError);

        expect(failure.originalError, originalError);
        expect(failure.message, 'An unexpected error occurred');
      });
    });
  });
}
