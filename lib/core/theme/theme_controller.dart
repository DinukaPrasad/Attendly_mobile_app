import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controller for managing the application theme mode.
///
/// This controller acts as the single source of truth for theme state,
/// persisting the user's preference to SharedPreferences and notifying
/// listeners when the theme changes.
class ThemeController extends ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';

  final SharedPreferences _prefs;
  ThemeMode _themeMode = ThemeMode.system;
  bool _isInitialized = false;

  ThemeController({required SharedPreferences prefs}) : _prefs = prefs;

  /// The current theme mode.
  ThemeMode get themeMode => _themeMode;

  /// Whether the controller has been initialized.
  bool get isInitialized => _isInitialized;

  /// Loads the saved theme mode from SharedPreferences.
  ///
  /// If no saved value exists, defaults to [ThemeMode.system].
  Future<void> loadThemeMode() async {
    final savedValue = _prefs.getString(_themeModeKey);
    _themeMode = _themeModeFromString(savedValue);
    _isInitialized = true;
    notifyListeners();
  }

  /// Sets the theme mode and persists it to SharedPreferences.
  ///
  /// Notifies all listeners after the change is saved.
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    await _prefs.setString(_themeModeKey, _themeModeToString(mode));
    notifyListeners();
  }

  /// Converts a string value to [ThemeMode].
  ThemeMode _themeModeFromString(String? value) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  /// Converts a [ThemeMode] to a string for storage.
  String _themeModeToString(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
  }
}
