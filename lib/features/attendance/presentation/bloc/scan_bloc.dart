import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_active_sessions.dart';
import '../../domain/usecases/submit_attendance.dart';
import '../../domain/usecases/validate_qr_code.dart';
import 'scan_event.dart';
import 'scan_state.dart';

/// BLoC for handling QR code scanning and attendance submission
class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final ValidateQrCode _validateQrCode;
  final SubmitAttendance _submitAttendance;
  final GetActiveSessions _getActiveSessions;

  ScanBloc({
    required ValidateQrCode validateQrCode,
    required SubmitAttendance submitAttendance,
    required GetActiveSessions getActiveSessions,
  }) : _validateQrCode = validateQrCode,
       _submitAttendance = submitAttendance,
       _getActiveSessions = getActiveSessions,
       super(const ScanInitial()) {
    on<ScanQrCodeEvent>(_onScanQrCode);
    on<SubmitAttendanceEvent>(_onSubmitAttendance);
    on<ResetScanEvent>(_onReset);
    on<LoadActiveSessionsEvent>(_onLoadActiveSessions);
  }

  Future<void> _onScanQrCode(
    ScanQrCodeEvent event,
    Emitter<ScanState> emit,
  ) async {
    emit(const ScanLoading(message: 'Validating QR code...'));

    final result = await _validateQrCode(
      ValidateQrCodeParams(qrCode: event.qrCode),
    );

    result.fold(
      onSuccess: (session) => emit(QrValidated(session: session)),
      onFailure: (failure) => emit(ScanError(message: failure.message)),
    );
  }

  Future<void> _onSubmitAttendance(
    SubmitAttendanceEvent event,
    Emitter<ScanState> emit,
  ) async {
    emit(const ScanLoading(message: 'Submitting attendance...'));

    final result = await _submitAttendance(
      SubmitAttendanceParams(
        sessionId: event.sessionId,
        userId: event.userId,
        qrCode: event.qrCode,
        latitude: event.latitude,
        longitude: event.longitude,
      ),
    );

    result.fold(
      onSuccess: (attendance) =>
          emit(AttendanceSubmitted(attendance: attendance)),
      onFailure: (failure) => emit(ScanError(message: failure.message)),
    );
  }

  Future<void> _onReset(ResetScanEvent event, Emitter<ScanState> emit) async {
    emit(const ScanInitial());
  }

  Future<void> _onLoadActiveSessions(
    LoadActiveSessionsEvent event,
    Emitter<ScanState> emit,
  ) async {
    emit(const ScanLoading(message: 'Loading active sessions...'));

    final result = await _getActiveSessions();

    result.fold(
      onSuccess: (sessions) => emit(ActiveSessionsLoaded(sessions: sessions)),
      onFailure: (failure) => emit(ScanError(message: failure.message)),
    );
  }
}
