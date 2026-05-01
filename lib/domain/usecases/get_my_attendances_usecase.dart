import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

class GetMyAttendancesUseCase {
  final AttendanceRepository repository;

  const GetMyAttendancesUseCase(this.repository);

  Future<List<Attendance>> call(int userId) {
    return repository.getAttendanceByUser(userId);
  }
}
