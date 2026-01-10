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
class ToggleBiometric implements UseCase<AppSettings, ToggleSettingParams> {
  final SettingsRepository _repository;

  ToggleBiometric(this._repository);

  @override
  Future<Result<AppSettings>> call(ToggleSettingParams params) {
    return _repository.toggleBiometric(params.enabled);
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
