import '../../domain/entities/attendance.dart';

/// Data model for Attendance with JSON serialization.
class AttendanceModel {
  final String id;
  final String sessionId;
  final String userId;
  final DateTime timestamp;
  final String status;
  final String? locationId;
  final double? latitude;
  final double? longitude;

  const AttendanceModel({
    required this.id,
    required this.sessionId,
    required this.userId,
    required this.timestamp,
    this.status = 'pending',
    this.locationId,
    this.latitude,
    this.longitude,
  });

  /// Creates an AttendanceModel from JSON
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] as String? ?? '',
      sessionId:
          json['sessionId'] as String? ?? json['session_id'] as String? ?? '',
      userId: json['userId'] as String? ?? json['user_id'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      status: json['status'] as String? ?? 'pending',
      locationId:
          json['locationId'] as String? ?? json['location_id'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'user_id': userId,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'location_id': locationId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  /// Converts to domain entity
  Attendance toEntity() {
    return Attendance(
      id: id,
      sessionId: sessionId,
      userId: userId,
      timestamp: timestamp,
      status: _parseStatus(status),
      locationId: locationId,
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Creates from domain entity
  factory AttendanceModel.fromEntity(Attendance entity) {
    return AttendanceModel(
      id: entity.id,
      sessionId: entity.sessionId,
      userId: entity.userId,
      timestamp: entity.timestamp,
      status: entity.status.name,
      locationId: entity.locationId,
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }

  AttendanceStatus _parseStatus(String status) {
    return AttendanceStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => AttendanceStatus.pending,
    );
  }

  /// Converts a list of JSON to list of AttendanceModel
  static List<AttendanceModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => AttendanceModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
