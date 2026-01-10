import 'package:get_it/get_it.dart';

import '../../features/auth/injection.dart';

/// Global service locator instance
final sl = GetIt.instance;

/// Initialize all dependencies
///
/// Call this in main() before runApp()
Future<void> initDependencies() async {
  // Initialize feature modules in order of dependency
  await _initCore();
  _initAuth();
  // Add more feature initializations here as you migrate them:
  // _initAttendance();
  // _initLocation();
  // _initProfile();
}

/// Initialize core dependencies (shared across all features)
Future<void> _initCore() async {
  // Storage service will be registered here
  // sl.registerLazySingleton<StorageService>(() => StorageServiceImpl());
}

/// Initialize auth feature dependencies
void _initAuth() {
  registerAuthDependencies(sl);
}

/// Reset all dependencies (useful for testing or logout)
Future<void> resetDependencies() async {
  await sl.reset();
}
