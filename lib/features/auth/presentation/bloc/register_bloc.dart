import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_up_email_password.dart';
import 'register_event.dart';
import 'register_state.dart';

/// BLoC for handling user registration
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final SignUpEmailPassword signUpEmailPassword;
  final SignInWithGoogle signInWithGoogle;

  RegisterBloc({
    required this.signUpEmailPassword,
    required this.signInWithGoogle,
  }) : super(const RegisterState.initial()) {
    on<RegisterEmailPressed>(_onEmailPressed);
    on<RegisterGooglePressed>(_onGooglePressed);
    on<RegisterNavigateToLogin>(_onNavigateToLogin);
  }

  Future<void> _onEmailPressed(
    RegisterEmailPressed event,
    Emitter<RegisterState> emit,
  ) async {
    // Validate passwords match first
    if (event.password != event.confirmPassword) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: 'Passwords do not match',
          isLoading: false,
        ),
      );
      return;
    }

    emit(state.copyWith(status: RegisterStatus.loading, isLoading: true));

    final result = await signUpEmailPassword(
      SignUpParams(email: event.email, password: event.password),
    );

    result.fold(
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: RegisterStatus.failure,
            errorMessage: failure.message,
            isLoading: false,
          ),
        );
      },
      onSuccess: (user) {
        emit(state.copyWith(status: RegisterStatus.success, isLoading: false));
      },
    );
  }

  Future<void> _onGooglePressed(
    RegisterGooglePressed event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.loading, isLoading: true));

    final result = await signInWithGoogle();

    result.fold(
      onFailure: (failure) {
        emit(
          state.copyWith(
            status: RegisterStatus.failure,
            errorMessage: failure.message,
            isLoading: false,
          ),
        );
      },
      onSuccess: (user) {
        emit(state.copyWith(status: RegisterStatus.success, isLoading: false));
      },
    );
  }

  void _onNavigateToLogin(
    RegisterNavigateToLogin event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(status: RegisterStatus.navigateToLogin));
  }
}
