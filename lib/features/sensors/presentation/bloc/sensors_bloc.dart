import 'package:bloc/bloc.dart';

import 'sensors_event.dart';
import 'sensors_state.dart';

class SensorsBloc extends Bloc<SensorsEvent, SensorsState> {
  SensorsBloc() : super(const SensorsState()) {
    on<SensorsStarted>(_onStarted);
  }

  void _onStarted(SensorsStarted event, Emitter<SensorsState> emit) {
    // TODO: read device sensors status.
    emit(state.copyWith(isAvailable: true));
  }
}
