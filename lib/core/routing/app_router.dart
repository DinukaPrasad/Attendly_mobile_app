import 'dart:async';

import 'package:attendly/core/constants/app_constants.dart';
import 'package:attendly/features/auth/injection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../di/di.dart';
import '../services/permission_manager.dart';
import '../../features/attendance/presentation/pages/history_screen.dart';
import '../../features/attendance/presentation/pages/home_screen.dart';
import '../../features/attendance/presentation/pages/scan_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/permissions/presentation/pages/permission_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../features/settings/presentation/pages/notifications_screen.dart';
import '../../features/settings/presentation/pages/settings_screen.dart';

/// Route paths as constants for type-safe navigation
class AppRoutes {
  AppRoutes._();

  static const String home = RouteConstants.home;
  static const String login = RouteConstants.login;
  static const String register = RouteConstants.register;
  static const String scan = RouteConstants.scan;
  static const String confirm = RouteConstants.confirm;
  static const String history = RouteConstants.history;
  static const String profile = RouteConstants.profile;
  static const String settings = RouteConstants.settings;
  static const String notifications = RouteConstants.notifications;
  static const String permissions = RouteConstants.permissions;
}

/// GoRouter configuration with auth-aware redirects
class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  /// Auth state notifier for router refresh
  static final _authNotifier = _AuthStateNotifier();

  /// The app router instance
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    refreshListenable: _authNotifier,
    redirect: _handleRedirect,
    routes: _routes,
  );

  /// Handle auth-based and permission-based redirects
  static String? _handleRedirect(BuildContext context, GoRouterState state) {
    final isLoggedIn = AuthDI.firebaseAuthService.currentUser != null;
    final isGoingToLogin = state.matchedLocation == AppRoutes.login;
    final isGoingToRegister = state.matchedLocation == AppRoutes.register;
    final isGoingToPermissions = state.matchedLocation == AppRoutes.permissions;
    final isAuthRoute = isGoingToLogin || isGoingToRegister;

    // If not logged in and not going to auth page, redirect to login
    if (!isLoggedIn && !isAuthRoute) {
      return AppRoutes.login;
    }

    // If logged in and going to auth page, check permission gate first
    if (isLoggedIn && isAuthRoute) {
      // Check if permission gate is completed
      final permissionManager = sl<PermissionManager>();
      if (!permissionManager.isPermissionGateDone) {
        return AppRoutes.permissions;
      }
      return AppRoutes.home;
    }

    // If logged in and not going to permissions, check if gate is done
    if (isLoggedIn && !isGoingToPermissions && !isAuthRoute) {
      final permissionManager = sl<PermissionManager>();
      if (!permissionManager.isPermissionGateDone) {
        return AppRoutes.permissions;
      }
    }

    // No redirect needed
    return null;
  }

  /// Route definitions
  static final List<RouteBase> _routes = [
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.permissions,
      name: 'permissions',
      builder: (context, state) => const PermissionScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.scan,
      name: 'scan',
      builder: (context, state) => const ScanScreen(),
    ),
    GoRoute(
      path: AppRoutes.history,
      name: 'history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      name: 'notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
  ];

  /// Refresh router when auth state changes
  static void refreshAuthState() {
    _authNotifier.notify();
  }
}

/// Listenable for auth state changes to trigger router refresh
class _AuthStateNotifier extends ChangeNotifier {
  late final StreamSubscription _subscription;

  _AuthStateNotifier() {
    _subscription = AuthDI.firebaseAuthService.authStateChanges().listen((_) {
      notifyListeners();
    });
  }

  void notify() => notifyListeners();

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
