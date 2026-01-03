import 'package:bloc/bloc.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppStateLoading()) {
    on<AppEventAppStarted>(_onStarted);
    on<AppEventLoginRequested>(_onLoginRequested);
    on<AppEventLogoutRequested>(_onLogoutRequested);

    add(const AppEventAppStarted());
  }

  void _onStarted(AppEventAppStarted event, Emitter<AppState> emit) {
    // TODO: Replace with persisted session check.
    emit(const AppStateUnauthenticated());
  }

  void _onLoginRequested(
    AppEventLoginRequested event,
    Emitter<AppState> emit,
  ) {
    // TODO: Replace with auth repository login.
    emit(const AppStateAuthenticated());
  }

  void _onLogoutRequested(
    AppEventLogoutRequested event,
    Emitter<AppState> emit,
  ) {
    // TODO: Replace with auth repository logout.
    emit(const AppStateUnauthenticated());
  }
}
