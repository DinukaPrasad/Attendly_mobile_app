import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

/// Parameters for SubmitAttendance use case
class SubmitAttendanceParams {
  final String sessionId;
  final String userId;
  final String qrCode;
  final double? latitude;
  final double? longitude;

  const SubmitAttendanceParams({
    required this.sessionId,
    required this.userId,
    required this.qrCode,
    this.latitude,
    this.longitude,
  });
}

/// Use case for submitting attendance.
class SubmitAttendance implements UseCase<Attendance, SubmitAttendanceParams> {
  final AttendanceRepository _repository;

  SubmitAttendance(this._repository);

  @override
  Future<Result<Attendance>> call(SubmitAttendanceParams params) {
    // Validate required fields
    if (params.sessionId.isEmpty) {
      return Future.value(
        Result.failure(
          const ValidationFailure(message: 'Session ID is required'),
        ),
      );
    }

    if (params.userId.isEmpty) {
      return Future.value(
        Result.failure(const ValidationFailure(message: 'User ID is required')),
      );
    }

    if (params.qrCode.isEmpty) {
      return Future.value(
        Result.failure(const ValidationFailure(message: 'QR code is required')),
      );
    }

    return _repository.submitAttendance(
      sessionId: params.sessionId,
      userId: params.userId,
      qrCode: params.qrCode,
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}
