import '../../domain/entities/attendance.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_remote_datasource.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remoteDataSource;

  const AttendanceRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Attendance>> getAttendanceByUser(int userId) {
    return remoteDataSource.getAttendanceByUser(userId);
  }

  @override
  Future<List<Attendance>> getAttendanceByProgramme(int programmeId) {
    return remoteDataSource.getAttendanceByProgramme(programmeId);
  }

  @override
  Future<Attendance> markAttendance(
    int userId,
    int programmeId,
    String time,
    String status, {
    double? latitude,
    double? longitude,
  }) {
    return remoteDataSource.markAttendance(
      userId: userId,
      programmeId: programmeId,
      time: time,
      status: status,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
