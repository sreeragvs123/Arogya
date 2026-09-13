import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/domain/repositories/patient_detail/patient_detail_repository.dart';

class SaveObservationsParams {
  final String patientId;
  final List<String> symptoms;
  final String clinicalNote;
  const SaveObservationsParams({
    required this.patientId,
    required this.symptoms,
    required this.clinicalNote,
  });
}

class SaveObservationsUsecase extends Usecase<Unit, SaveObservationsParams> {
  final PatientDetailRepository repository;
  SaveObservationsUsecase(this.repository);

  @override
  Future<Either<Failure, Unit>> call({required SaveObservationsParams params}) {
    return repository.saveObservations(
      patientId: params.patientId,
      symptoms: params.symptoms,
      clinicalNote: params.clinicalNote,
    );
  }
}
