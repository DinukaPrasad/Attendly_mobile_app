import 'package:equatable/equatable.dart';

abstract class SensorsEvent extends Equatable {
  const SensorsEvent();

  @override
  List<Object?> get props => [];
}

class SensorsStarted extends SensorsEvent {
  const SensorsStarted();
}
