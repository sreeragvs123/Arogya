// data/repositories/auth_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/data/resources/auth/auth_remote_datasource.dart';
import 'package:frontend/domain/entities/auth/auth_session.dart';
import 'package:frontend/domain/entities/auth/hospital.dart';
import 'package:frontend/domain/repositories/auth/auth_repository.dart';
import 'package:frontend/domain/usecases/auth/doctor_signin_usecase.dart';
import 'package:frontend/domain/usecases/auth/hospital_signin_usecase.dart';
import 'package:frontend/domain/usecases/auth/hosptial_create_usecase.dart';
import 'package:frontend/domain/usecases/auth/staff_signin_usecase.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  const AuthRepositoryImpl({required this.remoteDataSource});


  @override
  Future<Either<Failure, DoctorSession>> doctorSignIn(
    DoctorSignInParams params,
  ) async {
    try {
      final session = await remoteDataSource.doctorSignIn(
        hospitalId: params.hospitalId,
        doctorIdOrEmail: params.doctorIdOrEmail,
        password: params.password,
      );
      return Right(session);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
Future<Either<Failure, StaffSession>> staffSignIn(StaffSignInParams params) async {
  try {
    final session = await remoteDataSource.staffSignIn(
      hospitalId: params.hospitalId,
      department: params.department,
      staffIdOrEmail: params.staffIdOrEmail,
      password: params.password,
    );
    return Right(session);
  } on DioException catch (e) {
    return Left(_mapDioError(e));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}

  @override
  Future<Either<Failure, HospitalAdminSession>> hospitalSignIn(
    HospitalSignInParams params,
  ) async {
    try {
      final session = await remoteDataSource.hospitalSignIn(
        identifierOrEmail: params.identifierOrEmail,
        password: params.password,
      );
      return Right(session);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, Hospital>> createHospital(HospitalCreateParams params) async {
    try{
      final result = await remoteDataSource.createHospital(params: params);
      return Right(result);
    }on DioException catch (e) {
      print("error in dio${e.message!}");
      return Left(_mapDioError(e));
    }catch (e){
      print("error found in authImpl$e");
      return Left(ServerFailure(e.toString()));
    }
  }


  
  Failure _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkFailure('Unable to reach the server. Check your connection.');
    }

    final statusCode = e.response?.statusCode;
    if (statusCode == 401 || statusCode == 403) {
      return const AuthFailure('Invalid credentials.');
    }

    final backendMessage = e.response?.data is Map
        ? (e.response?.data['message'] as String?)
        : null;

    return ServerFailure(backendMessage ?? 'Something went wrong. Please try again.');
  }

}