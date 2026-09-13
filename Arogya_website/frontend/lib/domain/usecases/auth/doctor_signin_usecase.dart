import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/core/utils/service_locator.dart';
import 'package:frontend/domain/entities/auth/auth_session.dart';
import 'package:frontend/domain/repositories/auth/auth_repository.dart';

class DoctorSignInUsecase extends Usecase<AuthSession,DoctorSignInParams>{
  @override
  Future<Either<Failure, AuthSession>> call({required DoctorSignInParams params}) {
    return sl<AuthRepository>().doctorSignIn(params);
  }
}


class DoctorSignInParams{
  final int hospitalId;
  final String doctorIdOrEmail;
  final String password;

  DoctorSignInParams({required this.hospitalId, required this.doctorIdOrEmail, required this.password});
  
}