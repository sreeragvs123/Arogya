import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/domain/entities/patients/patient_summary_entity.dart';
import 'package:frontend/domain/repositories/patients/patients_repository.dart';

class GetActivePatientUsecase extends Usecase<PatientSummaryEntity?, NoParams> {
  final PatientsRepository repository;
  GetActivePatientUsecase(this.repository);

  @override
  Future<Either<Failure, PatientSummaryEntity?>> call({required NoParams params}) {
    return repository.getActivePatient();
  }
}
