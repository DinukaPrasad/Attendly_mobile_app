import 'package:bloc/bloc.dart';

import 'attendance_event.dart';
import 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  AttendanceBloc() : super(const AttendanceState()) {
    on<AttendanceScanRequested>(_onScanRequested);
  }

  Future<void> _onScanRequested(
    AttendanceScanRequested event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(state.copyWith(isScanning: true));
    // TODO: integrate with camera and QR scanning.
    emit(state.copyWith(isScanning: false));
  }
}
