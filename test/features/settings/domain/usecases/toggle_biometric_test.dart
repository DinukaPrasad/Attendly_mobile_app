import 'package:attendly/core/services/biometric_auth_service.dart';
import 'package:attendly/core/utils/result.dart';
import 'package:attendly/features/settings/domain/entities/app_settings.dart';
import 'package:attendly/features/settings/domain/repositories/settings_repository.dart';
import 'package:attendly/features/settings/domain/usecases/toggle_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockBiometricAuthService extends Mock implements BiometricAuthService {}

void main() {
  late MockSettingsRepository mockRepository;
  late MockBiometricAuthService mockBiometricService;
  late ToggleBiometric usecase;

  setUp(() {
    mockRepository = MockSettingsRepository();
    mockBiometricService = MockBiometricAuthService();
    usecase = ToggleBiometric(mockRepository, mockBiometricService);
  });

  const tSettingsEnabled = AppSettings(biometricEnabled: true);
  const tSettingsDisabled = AppSettings(biometricEnabled: false);

  group('ToggleBiometric', () {
    group('when enabling biometrics', () {
      test('should authenticate and persist true when auth succeeds', () async {
        // Arrange
        when(
          () => mockBiometricService.authenticate(reason: any(named: 'reason')),
        ).thenAnswer((_) async => const Result.success(true));
        when(
          () => mockRepository.toggleBiometric(true),
        ).thenAnswer((_) async => const Result.success(tSettingsEnabled));

        // Act
        final result = await usecase(const ToggleSettingParams(enabled: true));

        // Assert
        expect(result.isSuccess, true);
        expect(result.valueOrNull?.biometricEnabled, true);
        verify(
          () => mockBiometricService.authenticate(reason: any(named: 'reason')),
        ).called(1);
        verify(() => mockRepository.toggleBiometric(true)).called(1);
      });

      test(
        'should return failure and NOT persist when auth is cancelled',
        () async {
          // Arrange
          when(
            () =>
                mockBiometricService.authenticate(reason: any(named: 'reason')),
          ).thenAnswer(
            (_) async => Result.failure(BiometricFailure.cancelled()),
          );

          // Act
          final result = await usecase(
            const ToggleSettingParams(enabled: true),
          );

          // Assert
          expect(result.isFailure, true);
          expect(result.failureOrNull?.message, 'Authentication was cancelled');
          verify(
            () =>
                mockBiometricService.authenticate(reason: any(named: 'reason')),
          ).called(1);
          verifyNever(() => mockRepository.toggleBiometric(any()));
        },
      );

      test('should return failure when biometrics not available', () async {
        // Arrange
        when(
          () => mockBiometricService.authenticate(reason: any(named: 'reason')),
        ).thenAnswer(
          (_) async => Result.failure(BiometricFailure.notAvailable()),
        );

        // Act
        final result = await usecase(const ToggleSettingParams(enabled: true));

        // Assert
        expect(result.isFailure, true);
        expect(result.failureOrNull?.code, 'not-available');
        verifyNever(() => mockRepository.toggleBiometric(any()));
      });

      test('should return failure when no biometrics enrolled', () async {
        // Arrange
        when(
          () => mockBiometricService.authenticate(reason: any(named: 'reason')),
        ).thenAnswer(
          (_) async => Result.failure(BiometricFailure.notEnrolled()),
        );

        // Act
        final result = await usecase(const ToggleSettingParams(enabled: true));

        // Assert
        expect(result.isFailure, true);
        expect(result.failureOrNull?.code, 'not-enrolled');
        verifyNever(() => mockRepository.toggleBiometric(any()));
      });
    });

    group('when disabling biometrics', () {
      test('should persist false directly without authentication', () async {
        // Arrange
        when(
          () => mockRepository.toggleBiometric(false),
        ).thenAnswer((_) async => const Result.success(tSettingsDisabled));

        // Act
        final result = await usecase(const ToggleSettingParams(enabled: false));

        // Assert
        expect(result.isSuccess, true);
        expect(result.valueOrNull?.biometricEnabled, false);
        verifyNever(
          () => mockBiometricService.authenticate(reason: any(named: 'reason')),
        );
        verify(() => mockRepository.toggleBiometric(false)).called(1);
      });
    });
  });
}
