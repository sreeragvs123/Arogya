import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/domain/entities/doctor_dashboard/dashboard_summary_entity.dart';
import 'package:frontend/domain/repositories/doctor_dashboard/doctor_dashboard_repository.dart';

class GetDashboardSummaryUsecase
    extends Usecase<DashboardSummaryEntity, DoctorIdParam> {
  final DoctorDashboardRepository repository;
  GetDashboardSummaryUsecase(this.repository);

  @override
  Future<Either<Failure, DashboardSummaryEntity>> call({
    required DoctorIdParam params,
  }) {
    return repository.getDashboardSummary(params : params);
  }
}

class DoctorIdParam extends Equatable {
  final int doctorId;

  DoctorIdParam({required this.doctorId});

  @override
  List<Object?> get props => [doctorId];
}
