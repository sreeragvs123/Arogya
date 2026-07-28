import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'meds_event.dart';
part 'meds_state.dart';

class MedsBloc extends Bloc<MedsEvent, MedsState> {
  MedsBloc() : super(MedsInitial()) {
    on<MedsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
