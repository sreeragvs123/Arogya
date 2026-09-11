import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/domain/entities/auth/hospital.dart';

abstract class HospitalRepository {
  Future<Either<Failure, List<Hospital>>> searchHospitals(String query);
}