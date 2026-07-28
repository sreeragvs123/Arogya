import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'health_log_event.dart';
part 'health_log_state.dart';

class HealthLogBloc extends Bloc<HealthLogEvent, HealthLogState> {
  HealthLogBloc() : super(HealthLogInitial()) {
    on<HealthLogEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
