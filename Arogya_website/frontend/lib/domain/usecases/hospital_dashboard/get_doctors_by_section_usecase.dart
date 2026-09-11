// domain/usecases/hospital/get_doctors_by_section_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:frontend/common/paginated_result.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/core/utils/service_locator.dart';
import 'package:frontend/domain/entities/hosptial_dashboard/doctor_staff_section.dart';
import 'package:frontend/domain/entities/hosptial_dashboard/doctor_summary_entity.dart';
import 'package:frontend/domain/repositories/hospital_dashboard/hospital_dashboard_repository.dart';


class GetDoctorsBySectionUsecase extends Usecase<PaginatedResult<DoctorSummaryEntity>, GetDoctorsBySectionParams> {
  @override
  Future<Either<Failure, PaginatedResult<DoctorSummaryEntity>>> call({
    required GetDoctorsBySectionParams params,
  }) {
    return sl<HospitalDashboardRepository>().getDoctorsBySection(
      hospitalId: params.hospitalId,
      section: params.section,
      page: params.page,
      size: params.size,
    );
  }
}

class GetDoctorsBySectionParams {
  final int hospitalId;
  final DoctorStaffSection section;
  final int page;
  final int size;

  GetDoctorsBySectionParams({
    required this.hospitalId,
    required this.section,
    this.page = 0,
    this.size = 10,
  });
}