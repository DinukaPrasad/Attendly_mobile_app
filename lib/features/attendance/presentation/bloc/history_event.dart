import 'package:equatable/equatable.dart';

/// Base class for all history events
sealed class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load attendance history
class LoadHistoryEvent extends HistoryEvent {
  final String userId;

  const LoadHistoryEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Event to refresh attendance history
class RefreshHistoryEvent extends HistoryEvent {
  final String userId;

  const RefreshHistoryEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}
