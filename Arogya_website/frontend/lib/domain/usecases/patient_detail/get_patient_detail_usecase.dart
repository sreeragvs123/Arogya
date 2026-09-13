import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/domain/entities/patient_detail/patient_detail_entity.dart';
import 'package:frontend/domain/repositories/patient_detail/patient_detail_repository.dart';

class PatientIdParams {
  final String patientId;
  const PatientIdParams({required this.patientId});
}

class GetPatientDetailUsecase extends Usecase<PatientDetailEntity, PatientIdParams> {
  final PatientDetailRepository repository;
  GetPatientDetailUsecase(this.repository);

  @override
  Future<Either<Failure, PatientDetailEntity>> call({required PatientIdParams params}) {
    return repository.getPatientDetail(patientId: params.patientId);
  }
}
