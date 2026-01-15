import 'package:equatable/equatable.dart';

/// Entity representing an attendance session (e.g., a class period).
///
/// This is a pure Dart class with no external dependencies.
class AttendanceSession extends Equatable {
  final String id;
  final String name;
  final String courseId;
  final DateTime startTime;
  final DateTime endTime;
  final String? qrCode;
  final bool isActive;

  const AttendanceSession({
    required this.id,
    required this.name,
    required this.courseId,
    required this.startTime,
    required this.endTime,
    this.qrCode,
    this.isActive = false,
  });

  /// Check if the session is currently active based on time
  bool get isCurrentlyActive {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  /// Duration of the session
  Duration get duration => endTime.difference(startTime);

  @override
  List<Object?> get props => [
    id,
    name,
    courseId,
    startTime,
    endTime,
    qrCode,
    isActive,
  ];
}
