import 'package:attendly/features/settings/domain/entities/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppSettings', () {
    test('should create with default values', () {
      const settings = AppSettings();

      expect(settings.themeMode, AppThemeMode.system);
      expect(settings.notificationsEnabled, isTrue);
      expect(settings.biometricEnabled, isFalse);
      expect(settings.language, isNull);
      expect(settings.locationTrackingEnabled, isTrue);
    });

    test('should create with custom values', () {
      const settings = AppSettings(
        themeMode: AppThemeMode.dark,
        notificationsEnabled: false,
        biometricEnabled: true,
        language: 'en',
        locationTrackingEnabled: false,
      );

      expect(settings.themeMode, AppThemeMode.dark);
      expect(settings.notificationsEnabled, isFalse);
      expect(settings.biometricEnabled, isTrue);
      expect(settings.language, 'en');
      expect(settings.locationTrackingEnabled, isFalse);
    });

    group('copyWith', () {
      test('should copy with new themeMode', () {
        const original = AppSettings();
        final copied = original.copyWith(themeMode: AppThemeMode.light);

        expect(copied.themeMode, AppThemeMode.light);
        expect(copied.notificationsEnabled, original.notificationsEnabled);
        expect(copied.biometricEnabled, original.biometricEnabled);
      });

      test('should copy with new notificationsEnabled', () {
        const original = AppSettings();
        final copied = original.copyWith(notificationsEnabled: false);

        expect(copied.notificationsEnabled, isFalse);
        expect(copied.themeMode, original.themeMode);
      });

      test('should copy with new biometricEnabled', () {
        const original = AppSettings();
        final copied = original.copyWith(biometricEnabled: true);

        expect(copied.biometricEnabled, isTrue);
      });

      test('should copy with new language', () {
        const original = AppSettings();
        final copied = original.copyWith(language: 'fr');

        expect(copied.language, 'fr');
      });

      test('should copy with new locationTrackingEnabled', () {
        const original = AppSettings();
        final copied = original.copyWith(locationTrackingEnabled: false);

        expect(copied.locationTrackingEnabled, isFalse);
      });

      test('should return same values when no parameters passed', () {
        const original = AppSettings(
          themeMode: AppThemeMode.dark,
          notificationsEnabled: false,
          biometricEnabled: true,
          language: 'es',
          locationTrackingEnabled: false,
        );
        final copied = original.copyWith();

        expect(copied, equals(original));
      });
    });

    group('Equality', () {
      test('should be equal when all properties are the same', () {
        const settings1 = AppSettings(
          themeMode: AppThemeMode.dark,
          notificationsEnabled: true,
        );
        const settings2 = AppSettings(
          themeMode: AppThemeMode.dark,
          notificationsEnabled: true,
        );

        expect(settings1, equals(settings2));
      });

      test('should not be equal when properties differ', () {
        const settings1 = AppSettings(themeMode: AppThemeMode.dark);
        const settings2 = AppSettings(themeMode: AppThemeMode.light);

        expect(settings1, isNot(equals(settings2)));
      });
    });
  });

  group('AppThemeMode', () {
    test('should have three values', () {
      expect(AppThemeMode.values.length, 3);
      expect(AppThemeMode.values, contains(AppThemeMode.system));
      expect(AppThemeMode.values, contains(AppThemeMode.light));
      expect(AppThemeMode.values, contains(AppThemeMode.dark));
    });
  });
}
