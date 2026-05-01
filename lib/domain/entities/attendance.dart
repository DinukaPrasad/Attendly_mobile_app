class Attendance {
  final int? id;
  final int? userId;
  final String? userName;
  final int? programmeId;
  final String? programmeName;
  final String? time;
  final String? status;
  final String? createdAt;

  const Attendance({
    this.id,
    this.userId,
    this.userName,
    this.programmeId,
    this.programmeName,
    this.time,
    this.status,
    this.createdAt,
  });
}
