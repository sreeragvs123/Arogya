import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'blood_sugar_event.dart';
part 'blood_sugar_state.dart';

class BloodSugarBloc extends Bloc<BloodSugarEvent, BloodSugarState> {
  BloodSugarBloc() : super(BloodSugarInitial()) {
    on<BloodSugarEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
