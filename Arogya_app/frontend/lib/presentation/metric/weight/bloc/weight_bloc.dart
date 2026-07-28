import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'weight_event.dart';
part 'weight_state.dart';

class WeightBloc extends Bloc<WeightEvent, WeightState> {
  WeightBloc() : super(WeightInitial()) {
    on<WeightEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
