import '../../../../core/utils/result.dart';
import '../entities/app_settings.dart';

/// Abstract repository interface for settings operations.
///
/// This defines the contract that the data layer must implement.
///
/// NOTE: This is pure Dart - no Flutter imports allowed.
abstract class SettingsRepository {
  /// Gets the current application settings.
  Future<Result<AppSettings>> getSettings();

  /// Saves the application settings.
  Future<Result<void>> saveSettings(AppSettings settings);

  /// Updates a specific setting value.
  Future<Result<AppSettings>> updateThemeMode(AppThemeMode themeMode);

  /// Toggles notifications on/off.
  Future<Result<AppSettings>> toggleNotifications(bool enabled);

  /// Toggles biometric authentication on/off.
  Future<Result<AppSettings>> toggleBiometric(bool enabled);

  /// Toggles location tracking on/off.
  Future<Result<AppSettings>> toggleLocationTracking(bool enabled);

  /// Clears all settings and resets to defaults.
  Future<Result<void>> clearSettings();
}
