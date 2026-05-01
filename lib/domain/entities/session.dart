class Session {
  final int? id;
  final int? programmeId;
  final String? module;
  final String? lecturer;
  final String? title;
  final String? description;
  final String? venue;
  final String? startTime;
  final String? endTime;
  final String? sessionStatus;
  final bool? attendanceStatus;
  final String? code;

  const Session({
    this.id,
    this.programmeId,
    this.module,
    this.lecturer,
    this.title,
    this.description,
    this.venue,
    this.startTime,
    this.endTime,
    this.sessionStatus,
    this.attendanceStatus,
    this.code,
  });
}
