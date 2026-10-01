// presentation/hospital_doctor_dashboard/bloc/provision_doctor_event.dart
part of 'provision_doctor_bloc.dart';

sealed class ProvisionDoctorEvent extends Equatable {
  const ProvisionDoctorEvent();
  @override
  List<Object?> get props => [];
}

class ProvisionDoctorSubmitted extends ProvisionDoctorEvent {
  final CreateDoctorParams params;
  const ProvisionDoctorSubmitted(this.params);
  @override
  List<Object?> get props => [params];
}