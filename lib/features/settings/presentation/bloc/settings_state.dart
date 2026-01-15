import 'package:equatable/equatable.dart';

import '../../domain/entities/app_settings.dart';

/// Base class for all settings states
sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// Initial state before settings are loaded
class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

/// State while loading settings
class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

/// State when settings are loaded successfully
class SettingsLoaded extends SettingsState {
  final AppSettings settings;

  const SettingsLoaded({required this.settings});

  @override
  List<Object?> get props => [settings];
}

/// State when a settings operation fails
class SettingsError extends SettingsState {
  final String message;
  final AppSettings? previousSettings;

  const SettingsError({required this.message, this.previousSettings});

  @override
  List<Object?> get props => [message, previousSettings];
}

/// State when settings are being saved
class SettingsSaving extends SettingsState {
  final AppSettings currentSettings;

  const SettingsSaving({required this.currentSettings});

  @override
  List<Object?> get props => [currentSettings];
}

/// State when settings are cleared
class SettingsCleared extends SettingsState {
  const SettingsCleared();
}
