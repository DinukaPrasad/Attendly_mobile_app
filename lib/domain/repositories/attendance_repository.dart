import '../entities/attendance.dart';

abstract class AttendanceRepository {
  Future<List<Attendance>> getAttendanceByUser(int userId);

  Future<List<Attendance>> getAttendanceByProgramme(int programmeId);

  Future<Attendance> markAttendance(
    int userId,
    int programmeId,
    String time,
    String status, {
    double? latitude,
    double? longitude,
  });
}
