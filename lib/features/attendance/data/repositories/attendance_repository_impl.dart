import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/entities/attendance_session.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_remote_datasource.dart';

/// Implementation of [AttendanceRepository].
///
/// This connects the domain layer to the data layer by implementing
/// the abstract repository interface and delegating to the data source.
class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource _remoteDataSource;

  AttendanceRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Attendance>>> getAttendanceHistory(String userId) async {
    try {
      final models = await _remoteDataSource.getAttendanceHistory(userId);
      final entities = models.map((m) => m.toEntity()).toList();
      return Result.success(entities);
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.failure(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } catch (e) {
      return Result.failure(UnknownFailure(originalError: e));
    }
  }

  @override
  Future<Result<AttendanceSession>> getSessionById(String sessionId) async {
    try {
      final model = await _remoteDataSource.getSessionById(sessionId);
      return Result.success(model.toEntity());
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.failure(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } catch (e) {
      return Result.failure(UnknownFailure(originalError: e));
    }
  }

  @override
  Future<Result<List<AttendanceSession>>> getActiveSessions() async {
    try {
      final models = await _remoteDataSource.getActiveSessions();
      final entities = models.map((m) => m.toEntity()).toList();
      return Result.success(entities);
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.failure(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } catch (e) {
      return Result.failure(UnknownFailure(originalError: e));
    }
  }

  @override
  Future<Result<Attendance>> submitAttendance({
    required String sessionId,
    required String userId,
    required String qrCode,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final model = await _remoteDataSource.submitAttendance(
        sessionId: sessionId,
        userId: userId,
        qrCode: qrCode,
        latitude: latitude,
        longitude: longitude,
      );
      return Result.success(model.toEntity());
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.failure(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } catch (e) {
      return Result.failure(UnknownFailure(originalError: e));
    }
  }

  @override
  Future<Result<AttendanceSession>> validateQrCode(String qrCode) async {
    try {
      final model = await _remoteDataSource.validateQrCode(qrCode);
      return Result.success(model.toEntity());
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Result.failure(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } catch (e) {
      return Result.failure(UnknownFailure(originalError: e));
    }
  }
}
