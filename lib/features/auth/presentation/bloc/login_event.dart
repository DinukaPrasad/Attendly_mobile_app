import 'package:equatable/equatable.dart';

/// Base class for all login events
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// Event dispatched when user presses login with email/password
class LoginEmailPressed extends LoginEvent {
  final String email;
  final String password;

  const LoginEmailPressed({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Event dispatched when user presses Google sign-in button
class LoginGooglePressed extends LoginEvent {
  const LoginGooglePressed();
}

/// Event dispatched when user presses phone sign-in button
class LoginPhonePressed extends LoginEvent {
  const LoginPhonePressed();
}

/// Event to clear any error state
class LoginClearError extends LoginEvent {
  const LoginClearError();
}
