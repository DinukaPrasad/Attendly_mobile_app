import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

/// Parameters for GetAttendanceHistory use case
class GetAttendanceHistoryParams {
  final String userId;

  const GetAttendanceHistoryParams({required this.userId});
}

/// Use case for fetching attendance history for a user.
class GetAttendanceHistory
    implements UseCase<List<Attendance>, GetAttendanceHistoryParams> {
  final AttendanceRepository _repository;

  GetAttendanceHistory(this._repository);

  @override
  Future<Result<List<Attendance>>> call(GetAttendanceHistoryParams params) {
    if (params.userId.isEmpty) {
      return Future.value(
        Result.failure(const ValidationFailure(message: 'User ID is required')),
      );
    }
    return _repository.getAttendanceHistory(params.userId);
  }
}
