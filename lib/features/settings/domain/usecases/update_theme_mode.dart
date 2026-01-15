import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

/// Parameters for UpdateThemeMode use case
class UpdateThemeModeParams {
  final AppThemeMode themeMode;

  const UpdateThemeModeParams({required this.themeMode});
}

/// Use case for updating theme mode.
class UpdateThemeMode implements UseCase<AppSettings, UpdateThemeModeParams> {
  final SettingsRepository _repository;

  UpdateThemeMode(this._repository);

  @override
  Future<Result<AppSettings>> call(UpdateThemeModeParams params) {
    return _repository.updateThemeMode(params.themeMode);
  }
}
