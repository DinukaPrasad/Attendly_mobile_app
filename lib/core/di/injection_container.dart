import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../features/attendance/injection.dart';
import '../../features/auth/injection.dart';
import '../../features/profile/injection.dart';

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

  // Storage service will be registered here
  // sl.registerLazySingleton<StorageService>(() => StorageServiceImpl());
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

/// Reset all dependencies (useful for testing or logout)
Future<void> resetDependencies() async {
  await sl.reset();
}
