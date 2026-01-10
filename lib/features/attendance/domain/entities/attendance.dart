import 'package:equatable/equatable.dart';

/// Status of an attendance record
enum AttendanceStatus { pending, verified, rejected }

/// Entity representing an attendance record in the domain layer.
///
/// This is a pure Dart class with no external dependencies.
class Attendance extends Equatable {
  final String id;
  final String sessionId;
  final String userId;
  final DateTime timestamp;
  final AttendanceStatus status;
  final String? locationId;
  final double? latitude;
  final double? longitude;

  const Attendance({
    required this.id,
    required this.sessionId,
    required this.userId,
    required this.timestamp,
    this.status = AttendanceStatus.pending,
    this.locationId,
    this.latitude,
    this.longitude,
  });

  /// Check if the attendance has location data
  bool get hasLocation => latitude != null && longitude != null;

  @override
  List<Object?> get props => [
    id,
    sessionId,
    userId,
    timestamp,
    status,
    locationId,
    latitude,
    longitude,
  ];
}
