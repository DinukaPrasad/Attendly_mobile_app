import '../../domain/entities/attendance_session.dart';

/// Data model for AttendanceSession with JSON serialization.
class AttendanceSessionModel {
  final String id;
  final String name;
  final String courseId;
  final DateTime startTime;
  final DateTime endTime;
  final String? qrCode;
  final bool isActive;

  const AttendanceSessionModel({
    required this.id,
    required this.name,
    required this.courseId,
    required this.startTime,
    required this.endTime,
    this.qrCode,
    this.isActive = false,
  });

  /// Creates an AttendanceSessionModel from JSON
  factory AttendanceSessionModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSessionModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      courseId:
          json['courseId'] as String? ?? json['course_id'] as String? ?? '',
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'] as String)
          : json['start_time'] != null
          ? DateTime.parse(json['start_time'] as String)
          : DateTime.now(),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String)
          : DateTime.now(),
      qrCode: json['qrCode'] as String? ?? json['qr_code'] as String?,
      isActive:
          json['isActive'] as bool? ?? json['is_active'] as bool? ?? false,
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'course_id': courseId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'qr_code': qrCode,
      'is_active': isActive,
    };
  }

  /// Converts to domain entity
  AttendanceSession toEntity() {
    return AttendanceSession(
      id: id,
      name: name,
      courseId: courseId,
      startTime: startTime,
      endTime: endTime,
      qrCode: qrCode,
      isActive: isActive,
    );
  }

  /// Creates from domain entity
  factory AttendanceSessionModel.fromEntity(AttendanceSession entity) {
    return AttendanceSessionModel(
      id: entity.id,
      name: entity.name,
      courseId: entity.courseId,
      startTime: entity.startTime,
      endTime: entity.endTime,
      qrCode: entity.qrCode,
      isActive: entity.isActive,
    );
  }

  /// Converts a list of JSON to list of AttendanceSessionModel
  static List<AttendanceSessionModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map(
          (json) =>
              AttendanceSessionModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }
}
