// presentation/hospital_doctor_dashboard/bloc/provision_doctor_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/domain/usecases/hospital_dashboard/create_doctor_usecase.dart';

part 'provision_doctor_event.dart';
part 'provision_doctor_state.dart';

class ProvisionDoctorBloc
    extends Bloc<ProvisionDoctorEvent, ProvisionDoctorState> {
  final CreateDoctorUsecase createDoctorUsecase;

  ProvisionDoctorBloc({required this.createDoctorUsecase})
      : super(const ProvisionDoctorState()) {
    // droppable() ignores extra taps while a request is already running,
    // so a double-click can never create the doctor twice.
    on<ProvisionDoctorSubmitted>(_onSubmitted, transformer: droppable());
  }

  Future<void> _onSubmitted(
    ProvisionDoctorSubmitted event,
    Emitter<ProvisionDoctorState> emit,
  ) async {
    emit(state.copyWith(status: ProvisionDoctorStatus.submitting));

    final result = await createDoctorUsecase.call(params: event.params);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProvisionDoctorStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: ProvisionDoctorStatus.success,
        doctorName: event.params.fullName,
      )),
    );
  }
}