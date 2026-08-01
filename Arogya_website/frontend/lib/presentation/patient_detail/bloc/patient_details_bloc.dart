import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'patient_details_event.dart';
part 'patient_details_state.dart';

class PatientDetailsBloc extends Bloc<PatientDetailsEvent, PatientDetailsState> {
  PatientDetailsBloc() : super(PatientDetailsInitial()) {
    on<PatientDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
