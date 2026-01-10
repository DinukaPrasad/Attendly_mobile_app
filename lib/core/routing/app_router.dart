// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import '../../screens/attendance/confirm_screen.dart';
import '../../screens/attendance/history_screen.dart';
import '../../screens/attendance/scan_screen.dart';
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
  static const String confirm = '/confirm';
  static const String history = '/history';
  static const String profile = '/profile';
  static const String settings = '/settings';

  /// Route map for MaterialApp
  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    scan: (context) => const ScanScreen(),
    confirm: (context) => const ConfirmScreen(),
    history: (context) => const HistoryScreen(),
    profile: (context) => const ProfileScreen(),
    settings: (context) => const SettingsScreen(),
  };
}
