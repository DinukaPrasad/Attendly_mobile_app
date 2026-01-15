import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/sign_in_email_password.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import 'login_event.dart';
import 'login_state.dart';

/// BLoC for handling login screen logic.
///
/// This BLoC depends only on domain use cases, following Clean Architecture principles.
/// It handles state management for the login flow.
///
/// NOTE: Validation is now handled in use cases, keeping BLoC focused on state management.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SignInEmailPassword _signInEmailPassword;
  final SignInWithGoogle _signInWithGoogle;

  LoginBloc({
    required SignInEmailPassword signInEmailPassword,
    required SignInWithGoogle signInWithGoogle,
  }) : _signInEmailPassword = signInEmailPassword,
       _signInWithGoogle = signInWithGoogle,
       super(const LoginState.initial()) {
    on<LoginEmailPressed>(_onLoginEmailPressed);
    on<LoginGooglePressed>(_onLoginGooglePressed);
    on<LoginPhonePressed>(_onLoginPhonePressed);
    on<LoginClearError>(_onClearError);
  }

  /// Handles email/password login
  Future<void> _onLoginEmailPressed(
    LoginEmailPressed event,
    Emitter<LoginState> emit,
  ) async {
    // Prevent double submit
    if (state.isLoading) return;

    // Start loading
    emit(const LoginState.loading());

    // Call use case - validation is handled there
    final result = await _signInEmailPassword(
      SignInEmailPasswordParams(email: event.email, password: event.password),
    );

    // Handle result using fold pattern
    result.fold(
      onFailure: (failure) => emit(LoginState.failure(failure.message)),
      onSuccess: (_) => emit(const LoginState.success()),
    );
  }

  /// Handles Google sign-in
  Future<void> _onLoginGooglePressed(
    LoginGooglePressed event,
    Emitter<LoginState> emit,
  ) async {
    // Prevent double submit
    if (state.isLoading) return;

    emit(const LoginState.loading());

    final result = await _signInWithGoogle();

    result.fold(
      onFailure: (failure) {
        // If cancelled, return to initial state instead of showing error
        if (failure.code == 'cancelled') {
          emit(const LoginState.initial());
        } else {
          emit(LoginState.failure(failure.message));
        }
      },
      onSuccess: (_) => emit(const LoginState.success()),
    );
  }

  /// Handles phone sign-in navigation
  Future<void> _onLoginPhonePressed(
    LoginPhonePressed event,
    Emitter<LoginState> emit,
  ) async {
    // Simply emit navigation state - no auth logic here
    emit(const LoginState.navigateToPhone());
    // Reset to initial after navigation event is consumed
    emit(const LoginState.initial());
  }

  /// Clears error state
  void _onClearError(LoginClearError event, Emitter<LoginState> emit) {
    emit(const LoginState.initial());
  }
}
