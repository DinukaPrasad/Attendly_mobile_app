import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/usecases.dart';
import 'settings_event.dart';
import 'settings_state.dart';

/// BLoC for handling application settings
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettings _getSettings;
  final UpdateThemeMode _updateThemeMode;
  final ToggleNotifications _toggleNotifications;
  final ToggleBiometric _toggleBiometric;
  final ToggleLocationTracking _toggleLocationTracking;
  final ClearSettings _clearSettings;

  SettingsBloc({
    required GetSettings getSettings,
    required UpdateThemeMode updateThemeMode,
    required ToggleNotifications toggleNotifications,
    required ToggleBiometric toggleBiometric,
    required ToggleLocationTracking toggleLocationTracking,
    required ClearSettings clearSettings,
  }) : _getSettings = getSettings,
       _updateThemeMode = updateThemeMode,
       _toggleNotifications = toggleNotifications,
       _toggleBiometric = toggleBiometric,
       _toggleLocationTracking = toggleLocationTracking,
       _clearSettings = clearSettings,
       super(const SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateThemeModeEvent>(_onUpdateThemeMode);
    on<ToggleNotificationsEvent>(_onToggleNotifications);
    on<ToggleBiometricEvent>(_onToggleBiometric);
    on<ToggleLocationTrackingEvent>(_onToggleLocationTracking);
    on<ClearSettingsEvent>(_onClearSettings);
  }

  AppSettings? _getCurrentSettings() {
    final currentState = state;
    if (currentState is SettingsLoaded) {
      return currentState.settings;
    } else if (currentState is SettingsSaving) {
      return currentState.currentSettings;
    } else if (currentState is SettingsError) {
      return currentState.previousSettings;
    }
    return null;
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());

    final result = await _getSettings();

    result.fold(
      onSuccess: (settings) => emit(SettingsLoaded(settings: settings)),
      onFailure: (failure) => emit(SettingsError(message: failure.message)),
    );
  }

  Future<void> _onUpdateThemeMode(
    UpdateThemeModeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final current = _getCurrentSettings();
    if (current != null) {
      emit(SettingsSaving(currentSettings: current));
    }

    final result = await _updateThemeMode(
      UpdateThemeModeParams(themeMode: event.themeMode),
    );

    result.fold(
      onSuccess: (settings) => emit(SettingsLoaded(settings: settings)),
      onFailure: (failure) => emit(
        SettingsError(message: failure.message, previousSettings: current),
      ),
    );
  }

  Future<void> _onToggleNotifications(
    ToggleNotificationsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final current = _getCurrentSettings();
    if (current != null) {
      emit(SettingsSaving(currentSettings: current));
    }

    final result = await _toggleNotifications(
      ToggleSettingParams(enabled: event.enabled),
    );

    result.fold(
      onSuccess: (settings) => emit(SettingsLoaded(settings: settings)),
      onFailure: (failure) => emit(
        SettingsError(message: failure.message, previousSettings: current),
      ),
    );
  }

  Future<void> _onToggleBiometric(
    ToggleBiometricEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final current = _getCurrentSettings();
    if (current != null) {
      emit(SettingsSaving(currentSettings: current));
    }

    final result = await _toggleBiometric(
      ToggleSettingParams(enabled: event.enabled),
    );

    result.fold(
      onSuccess: (settings) => emit(SettingsLoaded(settings: settings)),
      onFailure: (failure) => emit(
        SettingsError(message: failure.message, previousSettings: current),
      ),
    );
  }

  Future<void> _onToggleLocationTracking(
    ToggleLocationTrackingEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final current = _getCurrentSettings();
    if (current != null) {
      emit(SettingsSaving(currentSettings: current));
    }

    final result = await _toggleLocationTracking(
      ToggleSettingParams(enabled: event.enabled),
    );

    result.fold(
      onSuccess: (settings) => emit(SettingsLoaded(settings: settings)),
      onFailure: (failure) => emit(
        SettingsError(message: failure.message, previousSettings: current),
      ),
    );
  }

  Future<void> _onClearSettings(
    ClearSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());

    final result = await _clearSettings();

    result.fold(
      onSuccess: (_) {
        emit(const SettingsCleared());
        // Reload default settings
        add(const LoadSettingsEvent());
      },
      onFailure: (failure) => emit(SettingsError(message: failure.message)),
    );
  }
}
