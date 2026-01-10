import 'package:attendly/core/errors/failures.dart';
import 'package:attendly/core/utils/result.dart';
import 'package:attendly/features/settings/domain/entities/app_settings.dart';
import 'package:attendly/features/settings/domain/repositories/settings_repository.dart';
import 'package:attendly/features/settings/domain/usecases/get_settings.dart';
import 'package:attendly/features/settings/domain/usecases/update_theme_mode.dart';
import 'package:attendly/features/settings/domain/usecases/toggle_settings.dart';
import 'package:attendly/features/settings/domain/usecases/clear_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
  });

  setUpAll(() {
    registerFallbackValue(AppThemeMode.system);
  });

  const tSettings = AppSettings(
    themeMode: AppThemeMode.dark,
    notificationsEnabled: true,
    biometricEnabled: false,
  );

  group('GetSettings', () {
    late GetSettings useCase;

    setUp(() {
      useCase = GetSettings(mockRepository);
    });

    test('should get settings from repository', () async {
      when(
        () => mockRepository.getSettings(),
      ).thenAnswer((_) async => const Result.success(tSettings));

      final result = await useCase();

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, tSettings);
      verify(() => mockRepository.getSettings()).called(1);
    });

    test('should return failure when repository fails', () async {
      const failure = CacheFailure(message: 'Cache error');
      when(
        () => mockRepository.getSettings(),
      ).thenAnswer((_) async => const Result.failure(failure));

      final result = await useCase();

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, failure);
    });
  });

  group('UpdateThemeMode', () {
    late UpdateThemeMode useCase;

    setUp(() {
      useCase = UpdateThemeMode(mockRepository);
    });

    test('should update theme mode in repository', () async {
      const updatedSettings = AppSettings(themeMode: AppThemeMode.light);
      when(
        () => mockRepository.updateThemeMode(AppThemeMode.light),
      ).thenAnswer((_) async => const Result.success(updatedSettings));

      final result = await useCase(
        const UpdateThemeModeParams(themeMode: AppThemeMode.light),
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.themeMode, AppThemeMode.light);
      verify(
        () => mockRepository.updateThemeMode(AppThemeMode.light),
      ).called(1);
    });

    test('should return failure when update fails', () async {
      const failure = CacheFailure(message: 'Write error');
      when(
        () => mockRepository.updateThemeMode(any()),
      ).thenAnswer((_) async => const Result.failure(failure));

      final result = await useCase(
        const UpdateThemeModeParams(themeMode: AppThemeMode.dark),
      );

      expect(result.isFailure, isTrue);
    });
  });

  group('ToggleNotifications', () {
    late ToggleNotifications useCase;

    setUp(() {
      useCase = ToggleNotifications(mockRepository);
    });

    test('should toggle notifications in repository', () async {
      const updatedSettings = AppSettings(notificationsEnabled: false);
      when(
        () => mockRepository.toggleNotifications(false),
      ).thenAnswer((_) async => const Result.success(updatedSettings));

      final result = await useCase(const ToggleSettingParams(enabled: false));

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.notificationsEnabled, isFalse);
      verify(() => mockRepository.toggleNotifications(false)).called(1);
    });
  });

  group('ToggleBiometric', () {
    late ToggleBiometric useCase;

    setUp(() {
      useCase = ToggleBiometric(mockRepository);
    });

    test('should toggle biometric in repository', () async {
      const updatedSettings = AppSettings(biometricEnabled: true);
      when(
        () => mockRepository.toggleBiometric(true),
      ).thenAnswer((_) async => const Result.success(updatedSettings));

      final result = await useCase(const ToggleSettingParams(enabled: true));

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.biometricEnabled, isTrue);
      verify(() => mockRepository.toggleBiometric(true)).called(1);
    });
  });

  group('ToggleLocationTracking', () {
    late ToggleLocationTracking useCase;

    setUp(() {
      useCase = ToggleLocationTracking(mockRepository);
    });

    test('should toggle location tracking in repository', () async {
      const updatedSettings = AppSettings(locationTrackingEnabled: false);
      when(
        () => mockRepository.toggleLocationTracking(false),
      ).thenAnswer((_) async => const Result.success(updatedSettings));

      final result = await useCase(const ToggleSettingParams(enabled: false));

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull?.locationTrackingEnabled, isFalse);
      verify(() => mockRepository.toggleLocationTracking(false)).called(1);
    });
  });

  group('ClearSettings', () {
    late ClearSettings useCase;

    setUp(() {
      useCase = ClearSettings(mockRepository);
    });

    test('should clear settings in repository', () async {
      when(
        () => mockRepository.clearSettings(),
      ).thenAnswer((_) async => const Result.success(null));

      final result = await useCase();

      expect(result.isSuccess, isTrue);
      verify(() => mockRepository.clearSettings()).called(1);
    });

    test('should return failure when clear fails', () async {
      const failure = CacheFailure(message: 'Clear error');
      when(
        () => mockRepository.clearSettings(),
      ).thenAnswer((_) async => const Result.failure(failure));

      final result = await useCase();

      expect(result.isFailure, isTrue);
    });
  });
}
