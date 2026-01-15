import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

/// Use case for fetching current settings.
class GetSettings implements UseCaseNoParams<AppSettings> {
  final SettingsRepository _repository;

  GetSettings(this._repository);

  @override
  Future<Result<AppSettings>> call() {
    return _repository.getSettings();
  }
}
