import '../../domain/entities/app_settings.dart';

/// Data model for AppSettings with JSON serialization.
class AppSettingsModel {
  final String themeMode;
  final bool notificationsEnabled;
  final bool biometricEnabled;
  final String? language;
  final bool locationTrackingEnabled;

  const AppSettingsModel({
    this.themeMode = 'system',
    this.notificationsEnabled = true,
    this.biometricEnabled = false,
    this.language,
    this.locationTrackingEnabled = true,
  });

  /// Creates an AppSettingsModel from JSON
  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      themeMode: json['theme_mode'] as String? ?? 'system',
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      biometricEnabled: json['biometric_enabled'] as bool? ?? false,
      language: json['language'] as String?,
      locationTrackingEnabled:
          json['location_tracking_enabled'] as bool? ?? true,
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'theme_mode': themeMode,
      'notifications_enabled': notificationsEnabled,
      'biometric_enabled': biometricEnabled,
      'language': language,
      'location_tracking_enabled': locationTrackingEnabled,
    };
  }

  /// Converts to domain entity
  AppSettings toEntity() {
    return AppSettings(
      themeMode: _parseThemeMode(themeMode),
      notificationsEnabled: notificationsEnabled,
      biometricEnabled: biometricEnabled,
      language: language,
      locationTrackingEnabled: locationTrackingEnabled,
    );
  }

  /// Creates from domain entity
  factory AppSettingsModel.fromEntity(AppSettings entity) {
    return AppSettingsModel(
      themeMode: entity.themeMode.name,
      notificationsEnabled: entity.notificationsEnabled,
      biometricEnabled: entity.biometricEnabled,
      language: entity.language,
      locationTrackingEnabled: entity.locationTrackingEnabled,
    );
  }

  AppThemeMode _parseThemeMode(String mode) {
    return AppThemeMode.values.firstWhere(
      (e) => e.name == mode,
      orElse: () => AppThemeMode.system,
    );
  }
}
