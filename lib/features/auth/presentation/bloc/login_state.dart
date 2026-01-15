import 'package:equatable/equatable.dart';

/// Enum representing the status of login operation
enum LoginStatus { initial, loading, success, failure, navigateToPhone }

/// State class for LoginBloc
class LoginState extends Equatable {
  final LoginStatus status;
  final String? errorMessage;

  const LoginState({this.status = LoginStatus.initial, this.errorMessage});

  /// Initial state
  const LoginState.initial()
    : status = LoginStatus.initial,
      errorMessage = null;

  /// Loading state
  const LoginState.loading()
    : status = LoginStatus.loading,
      errorMessage = null;

  /// Success state - login completed
  const LoginState.success()
    : status = LoginStatus.success,
      errorMessage = null;

  /// Failure state with error message
  const LoginState.failure(String message)
    : status = LoginStatus.failure,
      errorMessage = message;

  /// Navigate to phone login screen
  const LoginState.navigateToPhone()
    : status = LoginStatus.navigateToPhone,
      errorMessage = null;

  /// Helper to check if currently loading
  bool get isLoading => status == LoginStatus.loading;

  /// Copy with method for immutable state updates
  LoginState copyWith({LoginStatus? status, String? errorMessage}) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
