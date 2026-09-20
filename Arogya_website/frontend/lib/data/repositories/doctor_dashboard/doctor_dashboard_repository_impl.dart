import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/data/resources/doctor_dashboard/doctor_dashboard_remote_datasource.dart';
import 'package:frontend/domain/entities/doctor_dashboard/activity_entity.dart';
import 'package:frontend/domain/entities/doctor_dashboard/consultation_entity.dart';
import 'package:frontend/domain/entities/doctor_dashboard/dashboard_summary_entity.dart';
import 'package:frontend/domain/repositories/doctor_dashboard/doctor_dashboard_repository.dart';
import 'package:frontend/domain/usecases/doctor_dashboard/get_dashboard_summary_usecase.dart';

class DoctorDashboardRepositoryImpl implements DoctorDashboardRepository {
  final DoctorDashboardRemoteDataSource remoteDataSource;
  const DoctorDashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DashboardSummaryEntity>> getDashboardSummary({
    required DoctorIdParam params,
  }) async {
    try {
      print("form remoteSource : summary call going out");

      final result = await remoteDataSource.getDashboardSummary(
        params.doctorId,
      );
      print('remote source return : $result');
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ConsultationEntity>>>
  getUpcomingConsultations() async {
    try {
      final result = await remoteDataSource.getUpcomingConsultations();
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ActivityEntity>>> getRecentActivity({
    int limit = 10,
  }) async {
    try {
      final result = await remoteDataSource.getRecentActivity(limit: limit);
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> startConsultation({
    required String consultationId,
  }) async {
    try {
      await remoteDataSource.startConsultation(consultationId: consultationId);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> joinConsultationCall({
    required String consultationId,
  }) async {
    try {
      await remoteDataSource.joinConsultationCall(
        consultationId: consultationId,
      );
      return const Right(unit);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Failure _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkFailure(
        'Unable to reach the server. Check your connection.',
      );
    }
    final statusCode = e.response?.statusCode;
    if (statusCode == 401 || statusCode == 403) {
      return const AuthFailure('Not authorized.');
    }
    final backendMessage = e.response?.data is Map
        ? (e.response?.data['message'] as String?)
        : null;
    return ServerFailure(
      backendMessage ?? 'Something went wrong. Please try again.',
    );
  }
}
