import 'package:equatable/equatable.dart';

class AttendanceState extends Equatable {
  const AttendanceState({this.isScanning = false});

  final bool isScanning;

  AttendanceState copyWith({bool? isScanning}) {
    return AttendanceState(isScanning: isScanning ?? this.isScanning);
  }

  @override
  List<Object?> get props => [isScanning];
}
