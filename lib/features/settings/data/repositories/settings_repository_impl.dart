import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';
import '../models/app_settings_model.dart';

/// Implementation of [SettingsRepository].
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _localDataSource;

  SettingsRepositoryImpl(this._localDataSource);

  @override
  Future<Result<AppSettings>> getSettings() async {
    try {
      final model = await _localDataSource.getSettings();
      if (model == null) {
        // Return default settings if none saved
        return const Result.success(AppSettings());
      }
      return Result.success(model.toEntity());
    } on CacheException catch (e) {
      return Result.failure(CacheFailure(message: e.message));
    } catch (e) {
      return Result.failure(UnknownFailure(originalError: e));
    }
  }

  @override
  Future<Result<void>> saveSettings(AppSettings settings) async {
    try {
      final model = AppSettingsModel.fromEntity(settings);
      await _localDataSource.saveSettings(model);
      return const Result.success(null);
    } on CacheException catch (e) {
      return Result.failure(CacheFailure(message: e.message));
    } catch (e) {
      return Result.failure(UnknownFailure(originalError: e));
    }
  }

  @override
  Future<Result<AppSettings>> updateThemeMode(AppThemeMode themeMode) async {
    final currentResult = await getSettings();
    return currentResult.fold(
      onSuccess: (current) async {
        final updated = current.copyWith(themeMode: themeMode);
        final saveResult = await saveSettings(updated);
        return saveResult.fold(
          onSuccess: (_) => Result.success(updated),
          onFailure: (failure) => Result.failure(failure),
        );
      },
      onFailure: (failure) => Result.failure(failure),
    );
  }

  @override
  Future<Result<AppSettings>> toggleNotifications(bool enabled) async {
    final currentResult = await getSettings();
    return currentResult.fold(
      onSuccess: (current) async {
        final updated = current.copyWith(notificationsEnabled: enabled);
        final saveResult = await saveSettings(updated);
        return saveResult.fold(
          onSuccess: (_) => Result.success(updated),
          onFailure: (failure) => Result.failure(failure),
        );
      },
      onFailure: (failure) => Result.failure(failure),
    );
  }

  @override
  Future<Result<AppSettings>> toggleBiometric(bool enabled) async {
    final currentResult = await getSettings();
    return currentResult.fold(
      onSuccess: (current) async {
        final updated = current.copyWith(biometricEnabled: enabled);
        final saveResult = await saveSettings(updated);
        return saveResult.fold(
          onSuccess: (_) => Result.success(updated),
          onFailure: (failure) => Result.failure(failure),
        );
      },
      onFailure: (failure) => Result.failure(failure),
    );
  }

  @override
  Future<Result<AppSettings>> toggleLocationTracking(bool enabled) async {
    final currentResult = await getSettings();
    return currentResult.fold(
      onSuccess: (current) async {
        final updated = current.copyWith(locationTrackingEnabled: enabled);
        final saveResult = await saveSettings(updated);
        return saveResult.fold(
          onSuccess: (_) => Result.success(updated),
          onFailure: (failure) => Result.failure(failure),
        );
      },
      onFailure: (failure) => Result.failure(failure),
    );
  }

  @override
  Future<Result<void>> clearSettings() async {
    try {
      await _localDataSource.clearSettings();
      return const Result.success(null);
    } on CacheException catch (e) {
      return Result.failure(CacheFailure(message: e.message));
    } catch (e) {
      return Result.failure(UnknownFailure(originalError: e));
    }
  }
}
