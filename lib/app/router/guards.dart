import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../bloc/app_bloc.dart';
import '../bloc/app_state.dart';
import 'route_names.dart';

class AuthGuard {
  AuthGuard(this._appBloc);

  final AppBloc _appBloc;

  String? redirect(BuildContext context, GoRouterState state) {
    final currentState = _appBloc.state;
    final loggingIn = state.matchedLocation == RouteNames.login ||
        state.matchedLocation == RouteNames.register;

    if (currentState is AppStateLoading) {
      return loggingIn ? null : RouteNames.login;
    }

    if (currentState is AppStateAuthenticated && loggingIn) {
      return RouteNames.scan;
    }

    if (currentState is AppStateUnauthenticated && !loggingIn) {
      return RouteNames.login;
    }

    return null;
  }
}
