import 'package:bloc/bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<AuthLoginSubmitted>(_onLogin);
    on<AuthLogoutRequested>(_onLogout);
  }

  Future<void> _onLogin(AuthLoginSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    // TODO: connect with auth use cases.
    emit(state.copyWith(isLoading: false));
  }

  void _onLogout(AuthLogoutRequested event, Emitter<AuthState> emit) {
    // TODO: clear auth session.
  }
}
