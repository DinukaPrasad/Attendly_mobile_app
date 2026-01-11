import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/attendance/injection.dart';
import '../../features/auth/injection.dart';
import '../../features/profile/injection.dart';
import '../../features/settings/injection.dart';
import '../theme/theme_controller.dart';

/// Global service locator instance
final sl = GetIt.instance;

/// Initialize all dependencies
///
/// Call this in main() before runApp()
Future<void> initDependencies() async {
  // Initialize feature modules in order of dependency
  await _initCore();
  _initAuth();
  _initProfile();
  _initAttendance();
  await _initSettings();
}

/// Initialize core dependencies (shared across all features)
Future<void> _initCore() async {
  // HTTP client
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Base URL for API calls
  sl.registerLazySingleton<String>(
    () => 'https://api.attendly.example.com',
    instanceName: 'baseUrl',
  );

  // SharedPreferences for local storage
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // Theme controller (single source of truth for theme state)
  sl.registerLazySingleton<ThemeController>(
    () => ThemeController(prefs: prefs),
  );
}

/// Initialize auth feature dependencies
void _initAuth() {
  registerAuthDependencies(sl);
}

/// Initialize profile feature dependencies
void _initProfile() {
  registerProfileDependencies(sl);
}

/// Initialize attendance feature dependencies
void _initAttendance() {
  registerAttendanceDependencies(sl);
}

/// Initialize settings feature dependencies
Future<void> _initSettings() async {
  await registerSettingsDependencies(sl);
}

/// Reset all dependencies (useful for testing or logout)
Future<void> resetDependencies() async {
  await sl.reset();
}
