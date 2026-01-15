import 'package:equatable/equatable.dart';

import '../../domain/entities/app_settings.dart';

/// Base class for all settings events
sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load settings
class LoadSettingsEvent extends SettingsEvent {
  const LoadSettingsEvent();
}

/// Event to update theme mode
class UpdateThemeModeEvent extends SettingsEvent {
  final AppThemeMode themeMode;

  const UpdateThemeModeEvent({required this.themeMode});

  @override
  List<Object?> get props => [themeMode];
}

/// Event to toggle notifications
class ToggleNotificationsEvent extends SettingsEvent {
  final bool enabled;

  const ToggleNotificationsEvent({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

/// Event to toggle biometric authentication
class ToggleBiometricEvent extends SettingsEvent {
  final bool enabled;

  const ToggleBiometricEvent({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

/// Event to toggle location tracking
class ToggleLocationTrackingEvent extends SettingsEvent {
  final bool enabled;

  const ToggleLocationTrackingEvent({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

/// Event to clear all settings
class ClearSettingsEvent extends SettingsEvent {
  const ClearSettingsEvent();
}
