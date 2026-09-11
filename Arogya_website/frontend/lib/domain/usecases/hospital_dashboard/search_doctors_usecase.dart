
import 'package:dartz/dartz.dart';
import 'package:frontend/common/paginated_result.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/core/utils/service_locator.dart';
import 'package:frontend/domain/entities/hosptial_dashboard/doctor_staff_section.dart';
import 'package:frontend/domain/entities/hosptial_dashboard/doctor_summary_entity.dart';
import 'package:frontend/domain/repositories/hospital_dashboard/hospital_dashboard_repository.dart';


class SearchDoctorsUsecase
    extends Usecase<PaginatedResult<DoctorSummaryEntity>, SearchDoctorsParams> {
  @override
  Future<Either<Failure, PaginatedResult<DoctorSummaryEntity>>> call({
    required SearchDoctorsParams params,
  }) {
    return sl<HospitalDashboardRepository>().searchDoctorsByQuery(
      hospitalId: params.hospitalId,
      section: params.section,
      query: params.query,
      page: params.page,
      size: params.size,
    );
  }
}

class SearchDoctorsParams {
  final int hospitalId;
  final DoctorStaffSection section;
  final String query;
  final int page;
  final int size;

  SearchDoctorsParams({
    required this.hospitalId,
    required this.section,
    required this.query,
    this.page = 0,
    this.size = 10,
  });
}