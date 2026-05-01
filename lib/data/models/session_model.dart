import '../../domain/entities/session.dart';

class SessionModel extends Session {
  const SessionModel({
    super.id,
    super.programmeId,
    super.module,
    super.lecturer,
    super.title,
    super.description,
    super.venue,
    super.startTime,
    super.endTime,
    super.sessionStatus,
    super.attendanceStatus,
    super.code,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] as int?,
      programmeId: json['programmeId'] as int?,
      module: json['module'] as String?,
      lecturer: json['lecturer'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      venue: json['venue'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      sessionStatus: json['status'] as String? ?? json['sessionStatus'] as String?,
      attendanceStatus: json['attendanceStatus'] as bool?,
      code: json['code'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (programmeId != null) 'programmeId': programmeId,
    if (module != null) 'module': module,
    if (lecturer != null) 'lecturer': lecturer,
    if (title != null) 'title': title,
    if (description != null) 'description': description,
    if (venue != null) 'venue': venue,
    if (startTime != null) 'startTime': startTime,
    if (endTime != null) 'endTime': endTime,
    if (sessionStatus != null) 'sessionStatus': sessionStatus,
    if (attendanceStatus != null) 'attendanceStatus': attendanceStatus,
    if (code != null) 'code': code,
  };
}
