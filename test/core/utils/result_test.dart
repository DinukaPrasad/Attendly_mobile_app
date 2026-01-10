import 'package:attendly/core/utils/result.dart';
import 'package:attendly/core/errors/failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    group('Success', () {
      test('should create success result with value', () {
        const result = Result.success(42);

        expect(result.isSuccess, isTrue);
        expect(result.isFailure, isFalse);
        expect(result.valueOrNull, 42);
        expect(result.failureOrNull, isNull);
      });

      test('should return value in fold', () {
        const result = Result.success('hello');

        final output = result.fold(
          onSuccess: (value) => 'Got: $value',
          onFailure: (failure) => 'Error: ${failure.message}',
        );

        expect(output, 'Got: hello');
      });

      test('should map success value', () {
        const result = Result.success(10);

        final mapped = result.map((value) => value * 2);

        expect(mapped.isSuccess, isTrue);
        expect(mapped.valueOrNull, 20);
      });

      test('should flatMap success value', () {
        const result = Result.success(5);

        final flatMapped = result.flatMap(
          (value) => Result.success(value.toString()),
        );

        expect(flatMapped.isSuccess, isTrue);
        expect(flatMapped.valueOrNull, '5');
      });

      test('should return value with getOrThrow', () {
        const result = Result.success('test');

        expect(result.getOrThrow(), 'test');
      });

      test('should return value with getOrElse', () {
        const result = Result.success(100);

        expect(result.getOrElse(0), 100);
      });
    });

    group('Failure', () {
      test('should create failure result', () {
        const failure = NetworkFailure(message: 'No internet');
        const result = Result<int>.failure(failure);

        expect(result.isSuccess, isFalse);
        expect(result.isFailure, isTrue);
        expect(result.valueOrNull, isNull);
        expect(result.failureOrNull, failure);
      });

      test('should return failure in fold', () {
        const failure = ServerFailure(message: 'Server error');
        const result = Result<String>.failure(failure);

        final output = result.fold(
          onSuccess: (value) => 'Got: $value',
          onFailure: (failure) => 'Error: ${failure.message}',
        );

        expect(output, 'Error: Server error');
      });

      test('should not map failure', () {
        const failure = CacheFailure(message: 'Cache miss');
        const result = Result<int>.failure(failure);

        final mapped = result.map((value) => value * 2);

        expect(mapped.isFailure, isTrue);
        expect(mapped.failureOrNull, failure);
      });

      test('should not flatMap failure', () {
        const failure = AuthFailure(message: 'Unauthorized');
        const result = Result<int>.failure(failure);

        final flatMapped = result.flatMap(
          (value) => Result.success(value.toString()),
        );

        expect(flatMapped.isFailure, isTrue);
        expect(flatMapped.failureOrNull, failure);
      });

      test('should throw with getOrThrow', () {
        const failure = NetworkFailure(message: 'Offline');
        const result = Result<int>.failure(failure);

        expect(() => result.getOrThrow(), throwsA(isA<Failure>()));
      });

      test('should return default with getOrElse', () {
        const failure = NetworkFailure(message: 'Error');
        const result = Result<int>.failure(failure);

        expect(result.getOrElse(42), 42);
      });
    });

    group('Equality', () {
      test('success results with same value should be equal', () {
        const result1 = Result.success(42);
        const result2 = Result.success(42);

        expect(result1, equals(result2));
      });

      test('failure results with same failure should be equal', () {
        const failure = NetworkFailure(message: 'Error');
        const result1 = Result<int>.failure(failure);
        const result2 = Result<int>.failure(failure);

        expect(result1, equals(result2));
      });
    });
  });
}
