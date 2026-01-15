import 'package:equatable/equatable.dart';

/// Events for the Register BLoC
sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

/// User pressed the register button with email/password
final class RegisterEmailPressed extends RegisterEvent {
  final String email;
  final String password;
  final String confirmPassword;

  const RegisterEmailPressed({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [email, password, confirmPassword];
}

/// User pressed the Google sign-up button
final class RegisterGooglePressed extends RegisterEvent {
  const RegisterGooglePressed();
}

/// User pressed the back/login link
final class RegisterNavigateToLogin extends RegisterEvent {
  const RegisterNavigateToLogin();
}
