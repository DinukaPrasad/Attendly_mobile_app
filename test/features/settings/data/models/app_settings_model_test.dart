import 'package:attendly/features/settings/data/models/app_settings_model.dart';
import 'package:attendly/features/settings/domain/entities/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppSettingsModel', () {
    const tModel = AppSettingsModel(
      themeMode: 'dark',
      notificationsEnabled: false,
      biometricEnabled: true,
      language: 'en',
      locationTrackingEnabled: false,
    );

    const tEntity = AppSettings(
      themeMode: AppThemeMode.dark,
      notificationsEnabled: false,
      biometricEnabled: true,
      language: 'en',
      locationTrackingEnabled: false,
    );

    final tJson = {
      'theme_mode': 'dark',
      'notifications_enabled': false,
      'biometric_enabled': true,
      'language': 'en',
      'location_tracking_enabled': false,
    };

    group('fromJson', () {
      test('should create model from valid JSON', () {
        final result = AppSettingsModel.fromJson(tJson);

        expect(result.themeMode, 'dark');
        expect(result.notificationsEnabled, isFalse);
        expect(result.biometricEnabled, isTrue);
        expect(result.language, 'en');
        expect(result.locationTrackingEnabled, isFalse);
      });

      test('should use default values for missing fields', () {
        final result = AppSettingsModel.fromJson({});

        expect(result.themeMode, 'system');
        expect(result.notificationsEnabled, isTrue);
        expect(result.biometricEnabled, isFalse);
        expect(result.language, isNull);
        expect(result.locationTrackingEnabled, isTrue);
      });

      test('should handle null values', () {
        final result = AppSettingsModel.fromJson({
          'theme_mode': null,
          'notifications_enabled': null,
        });

        expect(result.themeMode, 'system');
        expect(result.notificationsEnabled, isTrue);
      });
    });

    group('toJson', () {
      test('should convert model to JSON', () {
        final result = tModel.toJson();

        expect(result['theme_mode'], 'dark');
        expect(result['notifications_enabled'], isFalse);
        expect(result['biometric_enabled'], isTrue);
        expect(result['language'], 'en');
        expect(result['location_tracking_enabled'], isFalse);
      });
    });

    group('toEntity', () {
      test('should convert model to entity', () {
        final result = tModel.toEntity();

        expect(result.themeMode, AppThemeMode.dark);
        expect(result.notificationsEnabled, isFalse);
        expect(result.biometricEnabled, isTrue);
        expect(result.language, 'en');
        expect(result.locationTrackingEnabled, isFalse);
      });

      test('should handle unknown theme mode', () {
        const model = AppSettingsModel(themeMode: 'unknown');
        final result = model.toEntity();

        expect(result.themeMode, AppThemeMode.system);
      });

      test('should parse all theme modes correctly', () {
        expect(
          const AppSettingsModel(themeMode: 'system').toEntity().themeMode,
          AppThemeMode.system,
        );
        expect(
          const AppSettingsModel(themeMode: 'light').toEntity().themeMode,
          AppThemeMode.light,
        );
        expect(
          const AppSettingsModel(themeMode: 'dark').toEntity().themeMode,
          AppThemeMode.dark,
        );
      });
    });

    group('fromEntity', () {
      test('should create model from entity', () {
        final result = AppSettingsModel.fromEntity(tEntity);

        expect(result.themeMode, 'dark');
        expect(result.notificationsEnabled, isFalse);
        expect(result.biometricEnabled, isTrue);
        expect(result.language, 'en');
        expect(result.locationTrackingEnabled, isFalse);
      });
    });

    group('Round trip', () {
      test('should maintain data through JSON round trip', () {
        final json = tModel.toJson();
        final fromJson = AppSettingsModel.fromJson(json);

        expect(fromJson.themeMode, tModel.themeMode);
        expect(fromJson.notificationsEnabled, tModel.notificationsEnabled);
        expect(fromJson.biometricEnabled, tModel.biometricEnabled);
        expect(fromJson.language, tModel.language);
        expect(
          fromJson.locationTrackingEnabled,
          tModel.locationTrackingEnabled,
        );
      });

      test('should maintain data through entity round trip', () {
        final entity = tModel.toEntity();
        final fromEntity = AppSettingsModel.fromEntity(entity);

        expect(fromEntity.themeMode, tModel.themeMode);
        expect(fromEntity.notificationsEnabled, tModel.notificationsEnabled);
        expect(fromEntity.biometricEnabled, tModel.biometricEnabled);
        expect(fromEntity.language, tModel.language);
        expect(
          fromEntity.locationTrackingEnabled,
          tModel.locationTrackingEnabled,
        );
      });
    });
  });
}
