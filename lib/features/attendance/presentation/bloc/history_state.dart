import 'package:equatable/equatable.dart';

import '../../domain/entities/attendance.dart';

/// Base class for all history states
sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any history action
class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

/// State while loading history
class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

/// State when history is loaded successfully
class HistoryLoaded extends HistoryState {
  final List<Attendance> attendanceList;

  const HistoryLoaded({required this.attendanceList});

  @override
  List<Object?> get props => [attendanceList];
}

/// State when history is empty
class HistoryEmpty extends HistoryState {
  const HistoryEmpty();
}

/// State when an error occurs
class HistoryError extends HistoryState {
  final String message;

  const HistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
