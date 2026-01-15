import 'package:equatable/equatable.dart';

import '../../domain/entities/attendance.dart';
import '../../domain/entities/attendance_session.dart';

/// Base class for all scan states
sealed class ScanState extends Equatable {
  const ScanState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any scan action
class ScanInitial extends ScanState {
  const ScanInitial();
}

/// State while validating QR code or submitting attendance
class ScanLoading extends ScanState {
  final String? message;

  const ScanLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// State when QR code is validated successfully
class QrValidated extends ScanState {
  final AttendanceSession session;

  const QrValidated({required this.session});

  @override
  List<Object?> get props => [session];
}

/// State when attendance is submitted successfully
class AttendanceSubmitted extends ScanState {
  final Attendance attendance;

  const AttendanceSubmitted({required this.attendance});

  @override
  List<Object?> get props => [attendance];
}

/// State when active sessions are loaded
class ActiveSessionsLoaded extends ScanState {
  final List<AttendanceSession> sessions;

  const ActiveSessionsLoaded({required this.sessions});

  @override
  List<Object?> get props => [sessions];
}

/// State when an error occurs
class ScanError extends ScanState {
  final String message;

  const ScanError({required this.message});

  @override
  List<Object?> get props => [message];
}
