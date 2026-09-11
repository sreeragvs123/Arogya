// domain/usecases/hospital/get_specializations_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/core/utils/service_locator.dart';
import 'package:frontend/domain/repositories/hospital_dashboard/hospital_dashboard_repository.dart';


class GetSpecializationsUsecase extends Usecase<List<String>, GetSpecializationsParams> {
  @override
  Future<Either<Failure, List<String>>> call({required GetSpecializationsParams params}) {
    return sl<HospitalDashboardRepository>().getSpecializations(hospitalId: params.hospitalId);
  }
}

class GetSpecializationsParams {
  final int hospitalId;
  GetSpecializationsParams({required this.hospitalId});
}