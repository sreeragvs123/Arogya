import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/domain/entities/patient_detail/patient_detail_entity.dart';
import 'package:frontend/domain/repositories/patient_detail/patient_detail_repository.dart';
import 'get_patient_detail_usecase.dart';

class GetVitalsUsecase extends Usecase<VitalsEntity, PatientIdParams> {
  final PatientDetailRepository repository;
  GetVitalsUsecase(this.repository);

  @override
  Future<Either<Failure, VitalsEntity>> call({required PatientIdParams params}) {
    return repository.getVitals(patientId: params.patientId);
  }
}
