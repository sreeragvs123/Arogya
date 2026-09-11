
import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/core/utils/service_locator.dart';
import 'package:frontend/domain/entities/auth/auth_session.dart';
import 'package:frontend/domain/repositories/auth/auth_repository.dart';

class HospitalSignInUsecase extends Usecase<AuthSession,HospitalSignInParams>{
  @override
  Future<Either<Failure, AuthSession>> call({required HospitalSignInParams params}) {
    return sl<AuthRepository>().hospitalSignIn(params);
  }
  
}

class HospitalSignInParams{
  final String identifierOrEmail;
  final String password;

  const HospitalSignInParams({
    required this.identifierOrEmail,
    required this.password,
  });
}