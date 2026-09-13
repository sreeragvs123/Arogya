import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/domain/entities/patients/patient_summary_entity.dart';
import 'package:frontend/domain/repositories/patients/patients_repository.dart';

class GetPatientsDirectorySummaryUsecase
    extends Usecase<PatientsDirectorySummaryEntity, NoParams> {
  final PatientsRepository repository;
  GetPatientsDirectorySummaryUsecase(this.repository);

  @override
  Future<Either<Failure, PatientsDirectorySummaryEntity>> call({required NoParams params}) {
    return repository.getDirectorySummary();
  }
}
