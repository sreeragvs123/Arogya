import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/core/utils/service_locator.dart';
import 'package:frontend/domain/entities/hosptial_dashboard/doctor_detail_entity.dart';
import 'package:frontend/domain/repositories/hospital_dashboard/hospital_dashboard_repository.dart';

class GetDoctorDetailUsecase extends Usecase<DoctorDetailEntity, GetDoctorDetailParams> {
  @override
  Future<Either<Failure, DoctorDetailEntity>> call({required GetDoctorDetailParams params}) {
    return sl<HospitalDashboardRepository>().getDoctorDetail(
      hospitalId: params.hospitalId,
      doctorId: params.doctorId,
    );
  }
}

class GetDoctorDetailParams {
  final int hospitalId;
  final int doctorId;
  const GetDoctorDetailParams({required this.hospitalId, required this.doctorId});
}