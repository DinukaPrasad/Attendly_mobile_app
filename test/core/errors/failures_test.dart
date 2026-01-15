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

        expect(failure.message, 'Network error. Please check your connection.');
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

      test('should include code', () {
        const failure = ServerFailure(
          message: 'Bad request',
          code: 'bad-request',
          statusCode: 400,
        );

        expect(failure.message, 'Bad request');
        expect(failure.code, 'bad-request');
        expect(failure.statusCode, 400);
      });
    });

    group('CacheFailure', () {
      test('should have correct message', () {
        const failure = CacheFailure(message: 'Failed to read cache');

        expect(failure.message, 'Failed to read cache');
      });

      test('should have default message', () {
        const failure = CacheFailure();

        expect(failure.message, 'Failed to access local storage');
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

      test('factory invalidCredentials should return correct failure', () {
        final failure = AuthFailure.invalidCredentials();

        expect(failure.message, 'Invalid email or password');
        expect(failure.code, 'invalid-credential');
      });

      test('factory userNotFound should return correct failure', () {
        final failure = AuthFailure.userNotFound();

        expect(failure.message, 'No account found with this email');
        expect(failure.code, 'user-not-found');
      });

      test('factory cancelled should return correct failure', () {
        final failure = AuthFailure.cancelled();

        expect(failure.message, 'Sign-in was cancelled');
        expect(failure.code, 'cancelled');
      });
    });

    group('ValidationFailure', () {
      test('should have custom message', () {
        const failure = ValidationFailure(
          message: 'Validation failed',
          code: 'validation-error',
        );

        expect(failure.message, 'Validation failed');
        expect(failure.code, 'validation-error');
      });

      test('factory emptyEmail should return correct failure', () {
        final failure = ValidationFailure.emptyEmail();

        expect(failure.message, 'Please enter your email');
        expect(failure.code, 'empty-email');
      });

      test('factory invalidEmail should return correct failure', () {
        final failure = ValidationFailure.invalidEmail();

        expect(failure.message, 'Please enter a valid email address');
        expect(failure.code, 'invalid-email');
      });

      test('factory emptyField should return correct failure', () {
        final failure = ValidationFailure.emptyField('username');

        expect(failure.message, 'Please enter username');
        expect(failure.code, 'empty-field');
      });
    });

    group('LocationFailure', () {
      test('factory permissionDenied should return correct failure', () {
        final failure = LocationFailure.permissionDenied();

        expect(failure.message, 'Location permission denied');
        expect(failure.code, 'permission-denied');
      });

      test('factory serviceDisabled should return correct failure', () {
        final failure = LocationFailure.serviceDisabled();

        expect(failure.message, 'Location services are disabled');
        expect(failure.code, 'service-disabled');
      });
    });

    group('UnknownFailure', () {
      test('should wrap original error', () {
        final originalError = Exception('Something went wrong');
        final failure = UnknownFailure(originalError: originalError);

        expect(failure.originalError, originalError);
        expect(failure.message, 'Something went wrong. Please try again');
      });

      test('should have default message without original error', () {
        const failure = UnknownFailure();

        expect(failure.message, 'Something went wrong. Please try again');
        expect(failure.originalError, isNull);
      });
    });
  });
}
