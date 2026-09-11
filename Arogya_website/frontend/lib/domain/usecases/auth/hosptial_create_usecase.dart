import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/core/utils/service_locator.dart';
import 'package:frontend/domain/entities/auth/hospital.dart';
import 'package:frontend/domain/repositories/auth/auth_repository.dart';

class HosptialCreateUsecase extends Usecase<Hospital,HospitalCreateParams>{
  @override
  Future<Either<Failure, Hospital>> call({required HospitalCreateParams params}) {
    return sl<AuthRepository>().createHospital(params);
  }

}


class HospitalCreateParams {
  final String hospitalName;
  final String facilityType;
  final String clinicalLicenseNumber;
  final String adminName;
  final String officialEmail;
  final String contactPhone;
  final String password;

  const HospitalCreateParams({
    required this.hospitalName,
    required this.facilityType,
    required this.clinicalLicenseNumber,
    required this.adminName,
    required this.officialEmail,
    required this.contactPhone,
    required this.password,
  });

    Map<String, dynamic> toJson() => {
        'hospitalName': hospitalName,
        'facilityType': facilityType.toUpperCase(),
        'clinicalLicenseNumber': clinicalLicenseNumber,
        'adminName': adminName,
        'officialEmail': officialEmail,
        'contactPhone': contactPhone,
        'password': password,
      };

}