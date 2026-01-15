import 'package:equatable/equatable.dart';

/// Base class for all scan events
sealed class ScanEvent extends Equatable {
  const ScanEvent();

  @override
  List<Object?> get props => [];
}

/// Event to scan and validate a QR code
class ScanQrCodeEvent extends ScanEvent {
  final String qrCode;

  const ScanQrCodeEvent({required this.qrCode});

  @override
  List<Object?> get props => [qrCode];
}

/// Event to submit attendance after QR validation
class SubmitAttendanceEvent extends ScanEvent {
  final String sessionId;
  final String userId;
  final String qrCode;
  final double? latitude;
  final double? longitude;

  const SubmitAttendanceEvent({
    required this.sessionId,
    required this.userId,
    required this.qrCode,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [sessionId, userId, qrCode, latitude, longitude];
}

/// Event to reset the scan state
class ResetScanEvent extends ScanEvent {
  const ResetScanEvent();
}

/// Event to load active sessions
class LoadActiveSessionsEvent extends ScanEvent {
  const LoadActiveSessionsEvent();
}
