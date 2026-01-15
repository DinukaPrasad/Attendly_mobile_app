import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_attendance_history.dart';
import 'history_event.dart';
import 'history_state.dart';

/// BLoC for handling attendance history
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetAttendanceHistory _getAttendanceHistory;

  HistoryBloc({required GetAttendanceHistory getAttendanceHistory})
    : _getAttendanceHistory = getAttendanceHistory,
      super(const HistoryInitial()) {
    on<LoadHistoryEvent>(_onLoadHistory);
    on<RefreshHistoryEvent>(_onRefreshHistory);
  }

  Future<void> _onLoadHistory(
    LoadHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryLoading());
    await _loadHistory(event.userId, emit);
  }

  Future<void> _onRefreshHistory(
    RefreshHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    await _loadHistory(event.userId, emit);
  }

  Future<void> _loadHistory(String userId, Emitter<HistoryState> emit) async {
    final result = await _getAttendanceHistory(
      GetAttendanceHistoryParams(userId: userId),
    );

    result.fold(
      onSuccess: (attendanceList) {
        if (attendanceList.isEmpty) {
          emit(const HistoryEmpty());
        } else {
          emit(HistoryLoaded(attendanceList: attendanceList));
        }
      },
      onFailure: (failure) => emit(HistoryError(message: failure.message)),
    );
  }
}
