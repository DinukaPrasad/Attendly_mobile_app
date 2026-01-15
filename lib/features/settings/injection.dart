import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/biometric_auth_service.dart';
import 'data/datasources/settings_local_datasource.dart';
import 'data/repositories/settings_repository_impl.dart';
import 'domain/repositories/settings_repository.dart';
import 'domain/usecases/usecases.dart';
import 'presentation/bloc/settings_bloc.dart';

/// Registers all settings feature dependencies.
Future<void> registerSettingsDependencies(GetIt sl) async {
  // Core Services (if not already registered)
  if (!sl.isRegistered<BiometricAuthService>()) {
    sl.registerLazySingleton<BiometricAuthService>(
      () => BiometricAuthServiceImpl(),
    );
  }

  // BLoC
  sl.registerFactory(
    () => SettingsBloc(
      getSettings: sl(),
      updateThemeMode: sl(),
      toggleNotifications: sl(),
      toggleBiometric: sl(),
      toggleLocationTracking: sl(),
      clearSettings: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetSettings(sl()));
  sl.registerLazySingleton(() => UpdateThemeMode(sl()));
  sl.registerLazySingleton(() => ToggleNotifications(sl()));
  sl.registerLazySingleton(() => ToggleBiometric(sl(), sl()));
  sl.registerLazySingleton(() => ToggleLocationTracking(sl()));
  sl.registerLazySingleton(() => ClearSettings(sl()));

  // Repository
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl()),
  );

  // Data Sources
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(prefs: sl<SharedPreferences>()),
  );
}
