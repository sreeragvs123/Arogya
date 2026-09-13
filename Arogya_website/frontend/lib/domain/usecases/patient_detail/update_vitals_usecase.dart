import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/domain/entities/patient_detail/patient_detail_entity.dart';
import 'package:frontend/domain/repositories/patient_detail/patient_detail_repository.dart';

class UpdateVitalsParams {
  final String patientId;
  final VitalsUpdateInput input;
  const UpdateVitalsParams({required this.patientId, required this.input});
}

class UpdateVitalsUsecase extends Usecase<VitalsEntity, UpdateVitalsParams> {
  final PatientDetailRepository repository;
  UpdateVitalsUsecase(this.repository);

  @override
  Future<Either<Failure, VitalsEntity>> call({required UpdateVitalsParams params}) {
    return repository.updateVitals(patientId: params.patientId, input: params.input);
  }
}
