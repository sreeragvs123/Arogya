import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/domain/repositories/hospital_dashboard/hospital_dashboard_repository.dart';

class CreateDoctorParams extends Equatable {
  final int hospitalId;
  final String fullName;
  final String licenseNumber;
  final String department;    // e.g. 'GENERAL_PHYSICIAN'
  final String designation;   // e.g. 'HOD'
  final String email;
  final String phoneNumber;
  final String temporaryPin;
  final bool prescriptionAuthority;
  final bool labImagingOrdering;
  final bool dischargeSignoffAuthority;

  const CreateDoctorParams({
    required this.hospitalId,
    required this.fullName,
    required this.licenseNumber,
    required this.department,
    required this.designation,
    required this.email,
    required this.phoneNumber,
    required this.temporaryPin,
    required this.prescriptionAuthority,
    required this.labImagingOrdering,
    required this.dischargeSignoffAuthority,
  });

  @override
  List<Object?> get props => [
        hospitalId,
        fullName,
        licenseNumber,
        department,
        designation,
        email,
        phoneNumber,
        temporaryPin,
        prescriptionAuthority,
        labImagingOrdering,
        dischargeSignoffAuthority,
      ];
}

class CreateDoctorUsecase implements Usecase<Unit, CreateDoctorParams> {
  final HospitalDashboardRepository repository;
  const CreateDoctorUsecase(this.repository);

  @override
  Future<Either<Failure, Unit>> call({required CreateDoctorParams params}) {
    return repository.createDoctor(params: params);
  }
}