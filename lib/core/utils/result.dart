import 'package:equatable/equatable.dart';
import '../errors/failures.dart';

/// A Result type that represents either a success value or a failure.
///
/// This is a simplified Either-like type specifically for our use case.
/// Use [Result.success] to create a success result with a value.
/// Use [Result.failure] to create a failure result with a Failure.
///
/// Example:
/// ```dart
/// Future<Result<User>> getUser() async {
///   try {
///     final user = await api.fetchUser();
///     return Result.success(user);
///   } catch (e) {
///     return Result.failure(NetworkFailure());
///   }
/// }
///
/// // Usage:
/// final result = await getUser();
/// result.fold(
///   onFailure: (failure) => showError(failure.message),
///   onSuccess: (user) => showUser(user),
/// );
/// ```
sealed class Result<T> extends Equatable {
  const Result._();

  /// Creates a success result with a value
  const factory Result.success(T value) = Success<T>;

  /// Creates a failure result with a Failure
  const factory Result.failure(Failure failure) = Fail<T>;

  /// Returns true if this is a success result
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a failure result
  bool get isFailure => this is Fail<T>;

  /// Gets the success value, or null if this is a failure
  T? get valueOrNull => switch (this) {
    Success(value: final v) => v,
    Fail() => null,
  };

  /// Gets the failure, or null if this is a success
  Failure? get failureOrNull => switch (this) {
    Success() => null,
    Fail(failure: final f) => f,
  };

  /// Fold over the result, calling the appropriate function
  R fold<R>({
    required R Function(Failure failure) onFailure,
    required R Function(T value) onSuccess,
  }) => switch (this) {
    Success(value: final v) => onSuccess(v),
    Fail(failure: final f) => onFailure(f),
  };

  /// Map the success value to a new value
  Result<R> map<R>(R Function(T value) mapper) => switch (this) {
    Success(value: final v) => Result.success(mapper(v)),
    Fail(failure: final f) => Result.failure(f),
  };

  /// FlatMap to chain Result-returning operations
  Result<R> flatMap<R>(Result<R> Function(T value) mapper) => switch (this) {
    Success(value: final v) => mapper(v),
    Fail(failure: final f) => Result.failure(f),
  };

  /// Get the value or throw the failure
  T getOrThrow() => switch (this) {
    Success(value: final v) => v,
    Fail(failure: final f) => throw f,
  };

  /// Get the value or return a default
  T getOrElse(T defaultValue) => switch (this) {
    Success(value: final v) => v,
    Fail() => defaultValue,
  };
}

/// Success variant of Result
final class Success<T> extends Result<T> {
  /// The success value
  final T value;

  /// Creates a success result
  const Success(this.value) : super._();

  @override
  List<Object?> get props => [value];
}

/// Failure variant of Result
final class Fail<T> extends Result<T> {
  /// The failure reason
  final Failure failure;

  /// Creates a failure result
  const Fail(this.failure) : super._();

  @override
  List<Object?> get props => [failure];
}

/// Extension to convert `Future<Result<T>>` to convenient async operations
extension ResultFutureExtension<T> on Future<Result<T>> {
  /// Fold the future result
  Future<R> foldAsync<R>({
    required R Function(Failure failure) onFailure,
    required R Function(T value) onSuccess,
  }) async {
    final result = await this;
    return result.fold(onFailure: onFailure, onSuccess: onSuccess);
  }
}
