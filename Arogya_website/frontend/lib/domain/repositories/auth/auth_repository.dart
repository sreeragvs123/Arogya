import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/domain/entities/auth/auth_session.dart';
import 'package:frontend/domain/entities/auth/hospital.dart';
import 'package:frontend/domain/usecases/auth/doctor_signin_usecase.dart';
import 'package:frontend/domain/usecases/auth/hospital_signin_usecase.dart';
import 'package:frontend/domain/usecases/auth/hosptial_create_usecase.dart';
import 'package:frontend/domain/usecases/auth/staff_signin_usecase.dart';

abstract class AuthRepository {
  Future<Either<Failure, DoctorSession>> doctorSignIn(DoctorSignInParams params);
  Future<Either<Failure, HospitalAdminSession>> hospitalSignIn(HospitalSignInParams params);
  Future<Either<Failure, Hospital>> createHospital(HospitalCreateParams params);
  Future<Either<Failure, StaffSession>> staffSignIn(StaffSignInParams params);
}