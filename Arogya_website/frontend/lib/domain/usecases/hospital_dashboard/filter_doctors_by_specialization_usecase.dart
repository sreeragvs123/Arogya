// domain/usecases/hospital/filter_doctors_by_specialization_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:frontend/common/paginated_result.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/core/utils/service_locator.dart';
import 'package:frontend/domain/entities/hosptial_dashboard/doctor_staff_section.dart';
import 'package:frontend/domain/entities/hosptial_dashboard/doctor_summary_entity.dart';
import 'package:frontend/domain/repositories/hospital_dashboard/hospital_dashboard_repository.dart';


class FilterDoctorsBySpecializationUsecase extends Usecase<PaginatedResult<DoctorSummaryEntity>, FilterDoctorsBySpecializationParams> {


  @override
  Future<Either<Failure, PaginatedResult<DoctorSummaryEntity>>> call({
    required FilterDoctorsBySpecializationParams params,
  }) {
    return sl<HospitalDashboardRepository>().filterDoctorsBySpecialization(
      hospitalId: params.hospitalId,
      section: params.section,
      specialization: params.specialization,
      page: params.page,
      size: params.size,
    );
  }

}

class FilterDoctorsBySpecializationParams {
  final int hospitalId;
  final DoctorStaffSection section;
  final String specialization;
  final int page;
  final int size;

  FilterDoctorsBySpecializationParams({
    required this.hospitalId,
    required this.section,
    required this.specialization,
    this.page = 0,
    this.size = 10,
  });
}