import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/core/utils/service_locator.dart';
import 'package:frontend/domain/entities/auth/auth_session.dart';
import 'package:frontend/domain/repositories/auth/auth_repository.dart';

class StaffSignInUsecase extends Usecase<AuthSession, StaffSignInParams> {
  @override
  Future<Either<Failure, AuthSession>> call({required StaffSignInParams params}) {
    return sl<AuthRepository>().staffSignIn(params);
  }
}

class StaffSignInParams {
  final int hospitalId;
  final String department;
  final String staffIdOrEmail;
  final String password;

  StaffSignInParams({
    required this.hospitalId,
    required this.department,
    required this.staffIdOrEmail,
    required this.password,
  });
}