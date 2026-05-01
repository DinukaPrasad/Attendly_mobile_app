import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

class MarkAttendanceUseCase {
  final AttendanceRepository repository;

  const MarkAttendanceUseCase(this.repository);

  Future<Attendance> call({
    required int userId,
    required int programmeId,
    required String time,
    required String status,
    double? latitude,
    double? longitude,
  }) {
    return repository.markAttendance(
      userId,
      programmeId,
      time,
      status,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
