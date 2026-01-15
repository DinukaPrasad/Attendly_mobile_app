import 'package:equatable/equatable.dart';

/// Status of the registration process
enum RegisterStatus { initial, loading, success, failure, navigateToLogin }

/// State for the Register BLoC
final class RegisterState extends Equatable {
  final RegisterStatus status;
  final String? errorMessage;
  final bool isLoading;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.errorMessage,
    this.isLoading = false,
  });

  /// Initial state
  const RegisterState.initial()
    : status = RegisterStatus.initial,
      errorMessage = null,
      isLoading = false;

  /// Creates a copy with optional new values
  RegisterState copyWith({
    RegisterStatus? status,
    String? errorMessage,
    bool? isLoading,
  }) {
    return RegisterState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, isLoading];
}
