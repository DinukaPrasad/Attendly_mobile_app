import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/settings_repository.dart';

/// Use case for clearing all settings.
class ClearSettings implements UseCaseNoParams<void> {
  final SettingsRepository _repository;

  ClearSettings(this._repository);

  @override
  Future<Result<void>> call() {
    return _repository.clearSettings();
  }
}
