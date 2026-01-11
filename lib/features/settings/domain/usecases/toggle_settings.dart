import '../../../../core/services/biometric_auth_service.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

/// Parameters for ToggleSetting use case
class ToggleSettingParams {
  final bool enabled;

  const ToggleSettingParams({required this.enabled});
}

/// Use case for toggling notifications.
class ToggleNotifications implements UseCase<AppSettings, ToggleSettingParams> {
  final SettingsRepository _repository;

  ToggleNotifications(this._repository);

  @override
  Future<Result<AppSettings>> call(ToggleSettingParams params) {
    return _repository.toggleNotifications(params.enabled);
  }
}

/// Use case for toggling biometric authentication.
///
/// When enabling biometrics:
/// 1. Checks if biometric auth is available on the device
/// 2. Prompts user to authenticate via biometrics
/// 3. Only persists enabled=true if authentication succeeds
///
/// When disabling biometrics:
/// - Directly persists enabled=false without requiring auth
class ToggleBiometric implements UseCase<AppSettings, ToggleSettingParams> {
  final SettingsRepository _repository;
  final BiometricAuthService _biometricService;

  ToggleBiometric(this._repository, this._biometricService);

  @override
  Future<Result<AppSettings>> call(ToggleSettingParams params) async {
    // If disabling, just persist without auth
    if (!params.enabled) {
      return _repository.toggleBiometric(false);
    }

    // If enabling, verify biometrics first
    final authResult = await _biometricService.authenticate(
      reason: 'Please authenticate to enable biometric login',
    );

    return authResult.fold(
      onSuccess: (_) => _repository.toggleBiometric(true),
      onFailure: (failure) => Result.failure(failure),
    );
  }
}

/// Use case for toggling location tracking.
class ToggleLocationTracking
    implements UseCase<AppSettings, ToggleSettingParams> {
  final SettingsRepository _repository;

  ToggleLocationTracking(this._repository);

  @override
  Future<Result<AppSettings>> call(ToggleSettingParams params) {
    return _repository.toggleLocationTracking(params.enabled);
  }
}
