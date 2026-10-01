// presentation/hospital_doctor_dashboard/bloc/provision_doctor_state.dart
part of 'provision_doctor_bloc.dart';

enum ProvisionDoctorStatus { initial, submitting, success, failure }

class ProvisionDoctorState extends Equatable {
  final ProvisionDoctorStatus status;
  final String? doctorName;
  final String? errorMessage;

  const ProvisionDoctorState({
    this.status = ProvisionDoctorStatus.initial,
    this.doctorName,
    this.errorMessage,
  });

  bool get isSubmitting => status == ProvisionDoctorStatus.submitting;

  ProvisionDoctorState copyWith({
    ProvisionDoctorStatus? status,
    String? doctorName,
    String? errorMessage,
  }) {
    return ProvisionDoctorState(
      status: status ?? this.status,
      doctorName: doctorName ?? this.doctorName,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, doctorName, errorMessage];
}