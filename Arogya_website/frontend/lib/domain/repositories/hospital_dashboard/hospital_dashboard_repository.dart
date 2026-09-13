// domain/repositories/hospital/hospital_dashboard_repository.dart
import 'package:dartz/dartz.dart';
import 'package:frontend/common/paginated_result.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/domain/entities/hosptial_dashboard/doctor_staff_section.dart';
import 'package:frontend/domain/entities/hosptial_dashboard/doctor_summary_entity.dart';
import 'package:frontend/domain/entities/hosptial_dashboard/hospital_metrics_entity.dart';
import 'package:frontend/domain/usecases/hospital_dashboard/create_doctor_usecase.dart';

abstract class HospitalDashboardRepository {
  Future<Either<Failure, PaginatedResult<DoctorSummaryEntity>>> getDoctorsBySection({
    required int hospitalId,
    required DoctorStaffSection section,
    required int page,
    required int size,
  });

  Future<Either<Failure, PaginatedResult<DoctorSummaryEntity>>> searchDoctorsByQuery({
    required int hospitalId,
    required DoctorStaffSection section,
    required String query,
    required int page,
    required int size,
  });

  Future<Either<Failure, PaginatedResult<DoctorSummaryEntity>>> filterDoctorsBySpecialization({
    required int hospitalId,
    required DoctorStaffSection section,
    required String specialization,
    required int page,
    required int size,
  });

  Future<Either<Failure, List<String>>> getSpecializations({required int hospitalId});

  Future<Either<Failure, HospitalMetricsEntity>> getMetrics({required int hospitalId});

  Future<Either<Failure, Unit>> createDoctor({required CreateDoctorParams params});
}