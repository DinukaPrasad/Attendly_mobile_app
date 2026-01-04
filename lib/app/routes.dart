// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import '../screens/attendance/confirm_screen.dart';
import '../screens/attendance/history_screen.dart';
import '../screens/attendance/scan_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/api_test.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String scan = '/scan';
  static const String confirm = '/confirm';
  static const String history = '/history';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String api_test = '/screens';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    scan: (context) => const ScanScreen(),
    confirm: (context) => const ConfirmScreen(),
    history: (context) => const HistoryScreen(),
    profile: (context) => const ProfileScreen(),
    settings: (context) => const SettingsScreen(),
    api_test: (context) => const ApiTest(),
  };
}
