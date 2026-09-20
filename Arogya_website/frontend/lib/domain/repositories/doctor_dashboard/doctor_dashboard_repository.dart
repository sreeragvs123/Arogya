import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/domain/entities/doctor_dashboard/activity_entity.dart';
import 'package:frontend/domain/entities/doctor_dashboard/consultation_entity.dart';
import 'package:frontend/domain/entities/doctor_dashboard/dashboard_summary_entity.dart';
import 'package:frontend/domain/usecases/doctor_dashboard/get_dashboard_summary_usecase.dart';

abstract class DoctorDashboardRepository {
  Future<Either<Failure, DashboardSummaryEntity>> getDashboardSummary({
    required DoctorIdParam params,
  });

  Future<Either<Failure, List<ConsultationEntity>>> getUpcomingConsultations();

  Future<Either<Failure, List<ActivityEntity>>> getRecentActivity({
    int limit = 10,
  });

  Future<Either<Failure, Unit>> startConsultation({
    required String consultationId,
  });

  Future<Either<Failure, Unit>> joinConsultationCall({
    required String consultationId,
  });
}
