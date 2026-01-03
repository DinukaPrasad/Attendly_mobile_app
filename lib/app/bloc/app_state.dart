import 'package:equatable/equatable.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];
}

class AppStateLoading extends AppState {
  const AppStateLoading();
}

class AppStateUnauthenticated extends AppState {
  const AppStateUnauthenticated();
}

class AppStateAuthenticated extends AppState {
  const AppStateAuthenticated();
}
