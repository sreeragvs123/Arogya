import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/domain/repositories/doctor_dashboard/doctor_dashboard_repository.dart';

class StartConsultationParams {
  final String consultationId;
  const StartConsultationParams({required this.consultationId});
}

class StartConsultationUsecase extends Usecase<Unit, StartConsultationParams> {
  final DoctorDashboardRepository repository;
  StartConsultationUsecase(this.repository);

  @override
  Future<Either<Failure, Unit>> call({required StartConsultationParams params}) {
    return repository.startConsultation(consultationId: params.consultationId);
  }
}
