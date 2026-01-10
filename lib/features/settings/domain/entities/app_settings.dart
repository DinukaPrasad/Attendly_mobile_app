import 'package:equatable/equatable.dart';

/// Represents the app theme mode
enum AppThemeMode { system, light, dark }

/// Entity representing application settings in the domain layer.
///
/// This is a pure Dart class with no external dependencies.
class AppSettings extends Equatable {
  final AppThemeMode themeMode;
  final bool notificationsEnabled;
  final bool biometricEnabled;
  final String? language;
  final bool locationTrackingEnabled;

  const AppSettings({
    this.themeMode = AppThemeMode.system,
    this.notificationsEnabled = true,
    this.biometricEnabled = false,
    this.language,
    this.locationTrackingEnabled = true,
  });

  /// Creates a copy with updated values
  AppSettings copyWith({
    AppThemeMode? themeMode,
    bool? notificationsEnabled,
    bool? biometricEnabled,
    String? language,
    bool? locationTrackingEnabled,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      language: language ?? this.language,
      locationTrackingEnabled:
          locationTrackingEnabled ?? this.locationTrackingEnabled,
    );
  }

  @override
  List<Object?> get props => [
    themeMode,
    notificationsEnabled,
    biometricEnabled,
    language,
    locationTrackingEnabled,
  ];
}
