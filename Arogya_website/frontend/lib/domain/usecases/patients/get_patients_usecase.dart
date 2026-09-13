import 'package:dartz/dartz.dart';
import 'package:frontend/common/paginated_result.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/domain/entities/patients/patient_summary_entity.dart';
import 'package:frontend/domain/repositories/patients/patients_repository.dart';

class GetPatientsParams {
  final String query;
  final String sortBy;
  final String condition;
  final int page;
  final int size;

  const GetPatientsParams({
    this.query = '',
    this.sortBy = 'Last Visited',
    this.condition = 'All Conditions',
    this.page = 0,
    this.size = 10,
  });
}

class GetPatientsUsecase
    extends Usecase<PaginatedResult<PatientSummaryEntity>, GetPatientsParams> {
  final PatientsRepository repository;
  GetPatientsUsecase(this.repository);

  @override
  Future<Either<Failure, PaginatedResult<PatientSummaryEntity>>> call({
    required GetPatientsParams params,
  }) {
    return repository.getPatients(
      query: params.query,
      sortBy: params.sortBy,
      condition: params.condition,
      page: params.page,
      size: params.size,
    );
  }
}
