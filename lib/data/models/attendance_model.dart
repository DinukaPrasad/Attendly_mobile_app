import '../../domain/entities/attendance.dart';

class AttendanceModel extends Attendance {
  const AttendanceModel({
    super.id,
    super.userId,
    super.userName,
    super.programmeId,
    super.programmeName,
    super.time,
    super.status,
    super.createdAt,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      userName: json['userName'] as String?,
      programmeId: json['programmeId'] as int?,
      programmeName: json['programmeName'] as String?,
      time: json['time'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (userId != null) 'userId': userId,
    if (userName != null) 'userName': userName,
    if (programmeId != null) 'programmeId': programmeId,
    if (programmeName != null) 'programmeName': programmeName,
    if (time != null) 'time': time,
    if (status != null) 'status': status,
    if (createdAt != null) 'createdAt': createdAt,
  };
}
