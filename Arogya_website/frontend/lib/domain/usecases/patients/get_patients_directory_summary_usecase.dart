import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/domain/entities/patients/patient_summary_entity.dart';
import 'package:frontend/domain/repositories/patients/patients_repository.dart';

class GetPatientsDirectorySummaryUsecase extends Usecase<PatientsDirectorySummaryEntity, DoctorHospitalParam> {
  final PatientsRepository repository;
  GetPatientsDirectorySummaryUsecase(this.repository);

  @override
  Future<Either<Failure, PatientsDirectorySummaryEntity>> call({
    required DoctorHospitalParam params,
  }) {
    return repository.getDirectorySummary(params);
  }
}

class DoctorHospitalParam {
  final int doctorId;
  final int hospitalId;

  DoctorHospitalParam({required this.doctorId, required this.hospitalId});
}

    