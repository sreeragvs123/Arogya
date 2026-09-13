import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/domain/entities/patients/patient_summary_entity.dart';
import 'package:frontend/domain/repositories/patients/patients_repository.dart';

class LookupPatientParams {
  final String identifier;
  const LookupPatientParams({required this.identifier});
}

class LookupPatientUsecase extends Usecase<PatientSummaryEntity, LookupPatientParams> {
  final PatientsRepository repository;
  LookupPatientUsecase(this.repository);

  @override
  Future<Either<Failure, PatientSummaryEntity>> call({required LookupPatientParams params}) {
    return repository.lookupPatient(identifier: params.identifier);
  }
}
