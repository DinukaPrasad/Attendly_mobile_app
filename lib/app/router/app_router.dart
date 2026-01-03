import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/attendance/presentation/pages/attendance_history_page.dart';
import '../../features/attendance/presentation/pages/confirm_attendance_page.dart';
import '../../features/attendance/presentation/pages/scan_qr_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../bloc/app_bloc.dart';
import 'guards.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter(this._appBloc) {
    final authGuard = AuthGuard(_appBloc);
    router = GoRouter(
      initialLocation: RouteNames.scan,
      refreshListenable: GoRouterRefreshStream(_appBloc.stream),
      redirect: authGuard.redirect,
      routes: _routes,
      debugLogDiagnostics: false,
    );
  }

  final AppBloc _appBloc;
  late final GoRouter router;

  List<GoRoute> get _routes => [
        GoRoute(
          path: RouteNames.login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: RouteNames.register,
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: RouteNames.scan,
          builder: (context, state) => const ScanQrPage(),
        ),
        GoRoute(
          path: RouteNames.confirm,
          builder: (context, state) => const ConfirmAttendancePage(),
        ),
        GoRoute(
          path: RouteNames.history,
          builder: (context, state) => const AttendanceHistoryPage(),
        ),
      ];

  void dispose() {
    router.dispose();
  }
}
