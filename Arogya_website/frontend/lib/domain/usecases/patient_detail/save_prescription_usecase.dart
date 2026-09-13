import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/domain/entities/patient_detail/patient_detail_entity.dart';
import 'package:frontend/domain/repositories/patient_detail/patient_detail_repository.dart';

class SavePrescriptionParams {
  final String patientId;
  final List<PrescriptionItemEntity> items;
  const SavePrescriptionParams({required this.patientId, required this.items});
}

class SavePrescriptionUsecase extends Usecase<Unit, SavePrescriptionParams> {
  final PatientDetailRepository repository;
  SavePrescriptionUsecase(this.repository);

  @override
  Future<Either<Failure, Unit>> call({required SavePrescriptionParams params}) {
    return repository.savePrescription(patientId: params.patientId, items: params.items);
  }
}
