import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/domain/repositories/doctor_dashboard/doctor_dashboard_repository.dart';

class JoinConsultationCallParams {
  final String consultationId;
  const JoinConsultationCallParams({required this.consultationId});
}

class JoinConsultationCallUsecase extends Usecase<Unit, JoinConsultationCallParams> {
  final DoctorDashboardRepository repository;
  JoinConsultationCallUsecase(this.repository);

  @override
  Future<Either<Failure, Unit>> call({required JoinConsultationCallParams params}) {
    return repository.joinConsultationCall(consultationId: params.consultationId);
  }
}
