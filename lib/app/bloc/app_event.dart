import 'package:equatable/equatable.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppEventAppStarted extends AppEvent {
  const AppEventAppStarted();
}

class AppEventLoginRequested extends AppEvent {
  const AppEventLoginRequested();
}

class AppEventLogoutRequested extends AppEvent {
  const AppEventLogoutRequested();
}
