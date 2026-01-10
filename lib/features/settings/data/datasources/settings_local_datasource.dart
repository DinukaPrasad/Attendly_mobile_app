import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/app_settings_model.dart';

/// Local data source for settings operations.
///
/// This handles local storage for app settings using SharedPreferences.
abstract class SettingsLocalDataSource {
  /// Gets the stored settings.
  Future<AppSettingsModel?> getSettings();

  /// Saves settings to local storage.
  Future<void> saveSettings(AppSettingsModel settings);

  /// Clears all settings from storage.
  Future<void> clearSettings();
}

/// Implementation of [SettingsLocalDataSource] using SharedPreferences.
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String _settingsKey = 'app_settings';

  final SharedPreferences _prefs;

  SettingsLocalDataSourceImpl({required SharedPreferences prefs})
    : _prefs = prefs;

  @override
  Future<AppSettingsModel?> getSettings() async {
    try {
      final jsonString = _prefs.getString(_settingsKey);
      if (jsonString == null) {
        return null;
      }
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return AppSettingsModel.fromJson(json);
    } catch (e) {
      throw CacheException(message: 'Failed to read settings: $e');
    }
  }

  @override
  Future<void> saveSettings(AppSettingsModel settings) async {
    try {
      final jsonString = jsonEncode(settings.toJson());
      await _prefs.setString(_settingsKey, jsonString);
    } catch (e) {
      throw CacheException(message: 'Failed to save settings: $e');
    }
  }

  @override
  Future<void> clearSettings() async {
    try {
      await _prefs.remove(_settingsKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear settings: $e');
    }
  }
}
