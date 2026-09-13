import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/domain/entities/doctor_dashboard/consultation_entity.dart';
import 'package:frontend/domain/repositories/doctor_dashboard/doctor_dashboard_repository.dart';

class GetUpcomingConsultationsUsecase extends Usecase<List<ConsultationEntity>, NoParams> {
  final DoctorDashboardRepository repository;
  GetUpcomingConsultationsUsecase(this.repository);

  @override
  Future<Either<Failure, List<ConsultationEntity>>> call({required NoParams params}) {
    return repository.getUpcomingConsultations();
  }
}
