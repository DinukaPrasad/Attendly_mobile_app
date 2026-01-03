import 'package:equatable/equatable.dart';

class SensorsState extends Equatable {
  const SensorsState({this.isAvailable = false});

  final bool isAvailable;

  SensorsState copyWith({bool? isAvailable}) {
    return SensorsState(isAvailable: isAvailable ?? this.isAvailable);
  }

  @override
  List<Object?> get props => [isAvailable];
}
