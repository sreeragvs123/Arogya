import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'blood_pressure_event.dart';
part 'blood_pressure_state.dart';

class BloodPressureBloc extends Bloc<BloodPressureEvent, BloodPressureState> {
  BloodPressureBloc() : super(BloodPressureInitial()) {
    on<BloodPressureEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
