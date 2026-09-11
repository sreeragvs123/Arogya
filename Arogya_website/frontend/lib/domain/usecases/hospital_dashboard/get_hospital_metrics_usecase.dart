// domain/usecases/hospital/get_hospital_metrics_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/core/utils/service_locator.dart';
import 'package:frontend/domain/entities/hosptial_dashboard/hospital_metrics_entity.dart';
import 'package:frontend/domain/repositories/hospital_dashboard/hospital_dashboard_repository.dart';

class GetHospitalMetricsUsecase extends Usecase<HospitalMetricsEntity, GetHospitalMetricsParams> {
  @override
  Future<Either<Failure, HospitalMetricsEntity>> call({
    required GetHospitalMetricsParams params,
  }) {
    return sl<HospitalDashboardRepository>().getMetrics(hospitalId: params.hospitalId);
  }
}

class GetHospitalMetricsParams {
  final int hospitalId;
  GetHospitalMetricsParams({required this.hospitalId});
}