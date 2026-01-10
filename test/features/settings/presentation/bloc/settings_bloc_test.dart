import 'package:attendly/core/errors/failures.dart';
import 'package:attendly/core/utils/result.dart';
import 'package:attendly/features/settings/domain/entities/app_settings.dart';
import 'package:attendly/features/settings/domain/usecases/usecases.dart';
import 'package:attendly/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:attendly/features/settings/presentation/bloc/settings_event.dart';
import 'package:attendly/features/settings/presentation/bloc/settings_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetSettings extends Mock implements GetSettings {}

class MockUpdateThemeMode extends Mock implements UpdateThemeMode {}

class MockToggleNotifications extends Mock implements ToggleNotifications {}

class MockToggleBiometric extends Mock implements ToggleBiometric {}

class MockToggleLocationTracking extends Mock
    implements ToggleLocationTracking {}

class MockClearSettings extends Mock implements ClearSettings {}

void main() {
  late MockGetSettings mockGetSettings;
  late MockUpdateThemeMode mockUpdateThemeMode;
  late MockToggleNotifications mockToggleNotifications;
  late MockToggleBiometric mockToggleBiometric;
  late MockToggleLocationTracking mockToggleLocationTracking;
  late MockClearSettings mockClearSettings;

  setUp(() {
    mockGetSettings = MockGetSettings();
    mockUpdateThemeMode = MockUpdateThemeMode();
    mockToggleNotifications = MockToggleNotifications();
    mockToggleBiometric = MockToggleBiometric();
    mockToggleLocationTracking = MockToggleLocationTracking();
    mockClearSettings = MockClearSettings();
  });

  setUpAll(() {
    registerFallbackValue(
      const UpdateThemeModeParams(themeMode: AppThemeMode.system),
    );
    registerFallbackValue(const ToggleSettingParams(enabled: true));
  });

  SettingsBloc buildBloc() => SettingsBloc(
    getSettings: mockGetSettings,
    updateThemeMode: mockUpdateThemeMode,
    toggleNotifications: mockToggleNotifications,
    toggleBiometric: mockToggleBiometric,
    toggleLocationTracking: mockToggleLocationTracking,
    clearSettings: mockClearSettings,
  );

  const tSettings = AppSettings(
    themeMode: AppThemeMode.system,
    notificationsEnabled: true,
    biometricEnabled: false,
    locationTrackingEnabled: true,
  );

  group('SettingsBloc', () {
    test('initial state should be SettingsInitial', () {
      final bloc = buildBloc();
      expect(bloc.state, const SettingsInitial());
    });

    group('LoadSettingsEvent', () {
      blocTest<SettingsBloc, SettingsState>(
        'emits [SettingsLoading, SettingsLoaded] when successful',
        build: () {
          when(
            () => mockGetSettings(),
          ).thenAnswer((_) async => const Result.success(tSettings));
          return buildBloc();
        },
        act: (bloc) => bloc.add(const LoadSettingsEvent()),
        expect: () => [
          const SettingsLoading(),
          const SettingsLoaded(settings: tSettings),
        ],
        verify: (_) {
          verify(() => mockGetSettings()).called(1);
        },
      );

      blocTest<SettingsBloc, SettingsState>(
        'emits [SettingsLoading, SettingsError] when fails',
        build: () {
          when(() => mockGetSettings()).thenAnswer(
            (_) async =>
                const Result.failure(CacheFailure(message: 'Cache error')),
          );
          return buildBloc();
        },
        act: (bloc) => bloc.add(const LoadSettingsEvent()),
        expect: () => [
          const SettingsLoading(),
          const SettingsError(message: 'Cache error'),
        ],
      );
    });

    group('UpdateThemeModeEvent', () {
      blocTest<SettingsBloc, SettingsState>(
        'emits [SettingsSaving, SettingsLoaded] when successful',
        build: () {
          when(
            () => mockGetSettings(),
          ).thenAnswer((_) async => const Result.success(tSettings));
          when(() => mockUpdateThemeMode(any())).thenAnswer(
            (_) async =>
                const Result.success(AppSettings(themeMode: AppThemeMode.dark)),
          );
          return buildBloc();
        },
        seed: () => const SettingsLoaded(settings: tSettings),
        act: (bloc) =>
            bloc.add(const UpdateThemeModeEvent(themeMode: AppThemeMode.dark)),
        expect: () => [
          const SettingsSaving(currentSettings: tSettings),
          const SettingsLoaded(
            settings: AppSettings(themeMode: AppThemeMode.dark),
          ),
        ],
        verify: (_) {
          verify(() => mockUpdateThemeMode(any())).called(1);
        },
      );

      blocTest<SettingsBloc, SettingsState>(
        'emits [SettingsSaving, SettingsError] with previousSettings when fails',
        build: () {
          when(() => mockUpdateThemeMode(any())).thenAnswer(
            (_) async =>
                const Result.failure(CacheFailure(message: 'Update failed')),
          );
          return buildBloc();
        },
        seed: () => const SettingsLoaded(settings: tSettings),
        act: (bloc) =>
            bloc.add(const UpdateThemeModeEvent(themeMode: AppThemeMode.light)),
        expect: () => [
          const SettingsSaving(currentSettings: tSettings),
          const SettingsError(
            message: 'Update failed',
            previousSettings: tSettings,
          ),
        ],
      );
    });

    group('ToggleNotificationsEvent', () {
      blocTest<SettingsBloc, SettingsState>(
        'emits [SettingsSaving, SettingsLoaded] when toggling notifications',
        build: () {
          when(() => mockToggleNotifications(any())).thenAnswer(
            (_) async =>
                const Result.success(AppSettings(notificationsEnabled: false)),
          );
          return buildBloc();
        },
        seed: () => const SettingsLoaded(settings: tSettings),
        act: (bloc) => bloc.add(const ToggleNotificationsEvent(enabled: false)),
        expect: () => [
          const SettingsSaving(currentSettings: tSettings),
          const SettingsLoaded(
            settings: AppSettings(notificationsEnabled: false),
          ),
        ],
      );
    });

    group('ToggleBiometricEvent', () {
      blocTest<SettingsBloc, SettingsState>(
        'emits [SettingsSaving, SettingsLoaded] when toggling biometric',
        build: () {
          when(() => mockToggleBiometric(any())).thenAnswer(
            (_) async =>
                const Result.success(AppSettings(biometricEnabled: true)),
          );
          return buildBloc();
        },
        seed: () => const SettingsLoaded(settings: tSettings),
        act: (bloc) => bloc.add(const ToggleBiometricEvent(enabled: true)),
        expect: () => [
          const SettingsSaving(currentSettings: tSettings),
          const SettingsLoaded(settings: AppSettings(biometricEnabled: true)),
        ],
      );
    });

    group('ToggleLocationTrackingEvent', () {
      blocTest<SettingsBloc, SettingsState>(
        'emits [SettingsSaving, SettingsLoaded] when toggling location tracking',
        build: () {
          when(() => mockToggleLocationTracking(any())).thenAnswer(
            (_) async => const Result.success(
              AppSettings(locationTrackingEnabled: false),
            ),
          );
          return buildBloc();
        },
        seed: () => const SettingsLoaded(settings: tSettings),
        act: (bloc) =>
            bloc.add(const ToggleLocationTrackingEvent(enabled: false)),
        expect: () => [
          const SettingsSaving(currentSettings: tSettings),
          const SettingsLoaded(
            settings: AppSettings(locationTrackingEnabled: false),
          ),
        ],
      );
    });

    group('ClearSettingsEvent', () {
      blocTest<SettingsBloc, SettingsState>(
        'emits [SettingsLoading, SettingsCleared, ...] when clearing settings',
        build: () {
          when(
            () => mockClearSettings(),
          ).thenAnswer((_) async => const Result.success(null));
          when(
            () => mockGetSettings(),
          ).thenAnswer((_) async => const Result.success(AppSettings()));
          return buildBloc();
        },
        seed: () => const SettingsLoaded(settings: tSettings),
        act: (bloc) => bloc.add(const ClearSettingsEvent()),
        expect: () => [
          const SettingsLoading(),
          const SettingsCleared(),
          const SettingsLoading(),
          const SettingsLoaded(settings: AppSettings()),
        ],
        verify: (_) {
          verify(() => mockClearSettings()).called(1);
          verify(() => mockGetSettings()).called(1);
        },
      );

      blocTest<SettingsBloc, SettingsState>(
        'emits [SettingsLoading, SettingsError] when clear fails',
        build: () {
          when(() => mockClearSettings()).thenAnswer(
            (_) async =>
                const Result.failure(CacheFailure(message: 'Clear failed')),
          );
          return buildBloc();
        },
        act: (bloc) => bloc.add(const ClearSettingsEvent()),
        expect: () => [
          const SettingsLoading(),
          const SettingsError(message: 'Clear failed'),
        ],
      );
    });
  });
}
