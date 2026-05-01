import '../models/attendance_model.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';

class AttendanceRemoteDataSource {
  final ApiClient _apiClient;

  AttendanceRemoteDataSource({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<List<AttendanceModel>> getAttendanceByUser(int userId) async {
    final data = await _apiClient.get(
      '${ApiConstants.attendanceByUser}/$userId',
    );
    final List<dynamic> attendanceList = data is List
        ? data
        : data['data'] ?? [];
    return attendanceList
        .map(
          (attendance) =>
              AttendanceModel.fromJson(attendance as Map<String, dynamic>),
        )
        .toList();
  }

  Future<List<AttendanceModel>> getAttendanceByProgramme(
    int programmeId,
  ) async {
    final data = await _apiClient.get(
      '${ApiConstants.attendanceByProgramme}/$programmeId',
    );
    final List<dynamic> attendanceList = data is List
        ? data
        : data['data'] ?? [];
    return attendanceList
        .map(
          (attendance) =>
              AttendanceModel.fromJson(attendance as Map<String, dynamic>),
        )
        .toList();
  }

  Future<AttendanceModel> markAttendance({
    required int userId,
    required int programmeId,
    required String time,
    required String status,
    double? latitude,
    double? longitude,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.attendance,
      body: {
        'userId': userId,
        'programmeId': programmeId,
        'time': time,
        'status': status,
        'latitude': ?latitude,
        'longitude': ?longitude,
      },
    );
    // Backend wraps response in ApiResponse<AttendanceResponse> — extract data.
    final data = response['data'] as Map<String, dynamic>? ?? response;
    return AttendanceModel.fromJson(data);
  }
}
