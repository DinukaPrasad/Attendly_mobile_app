import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/attendance_session.dart';
import '../repositories/attendance_repository.dart';

/// Use case for fetching active sessions.
class GetActiveSessions implements UseCaseNoParams<List<AttendanceSession>> {
  final AttendanceRepository _repository;

  GetActiveSessions(this._repository);

  @override
  Future<Result<List<AttendanceSession>>> call() {
    return _repository.getActiveSessions();
  }
}
