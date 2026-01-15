import '../../../../core/utils/result.dart';
import '../entities/attendance.dart';
import '../entities/attendance_session.dart';

/// Abstract repository interface for attendance operations.
///
/// This defines the contract that the data layer must implement.
///
/// NOTE: This is pure Dart - no Flutter or HTTP imports allowed.
abstract class AttendanceRepository {
  /// Gets the attendance history for a user.
  Future<Result<List<Attendance>>> getAttendanceHistory(String userId);

  /// Gets a specific session by ID.
  Future<Result<AttendanceSession>> getSessionById(String sessionId);

  /// Gets all active sessions available for check-in.
  Future<Result<List<AttendanceSession>>> getActiveSessions();

  /// Submits attendance for a session.
  Future<Result<Attendance>> submitAttendance({
    required String sessionId,
    required String userId,
    required String qrCode,
    double? latitude,
    double? longitude,
  });

  /// Validates a QR code and returns the associated session.
  Future<Result<AttendanceSession>> validateQrCode(String qrCode);
}
