// ignore_for_file: constant_identifier_names, unused_import

import 'package:flutter/material.dart';

import '../../features/attendance/presentation/pages/confirm_screen.dart';
import '../../features/attendance/presentation/pages/history_screen.dart';
import '../../features/attendance/presentation/pages/scan_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../screens/settings/settings_screen.dart';

/// Application route definitions
class AppRoutes {
  AppRoutes._();

  // Route names
  static const String login = '/login';
  static const String register = '/register';
  static const String scan = '/scan';
  static const String confirm =
      '/confirm'; // Navigate with Navigator.push + session param
  static const String history = '/history';
  static const String profile = '/profile';
  static const String settings = '/settings';

  /// Route map for MaterialApp
  /// Note: ConfirmScreen is not included here as it requires a session parameter.
  /// Use Navigator.push to navigate to ConfirmScreen with the session data.
  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    scan: (context) => const ScanScreen(),
    history: (context) => const HistoryScreen(),
    profile: (context) => const ProfileScreen(),
    settings: (context) => const SettingsScreen(),
  };
}
