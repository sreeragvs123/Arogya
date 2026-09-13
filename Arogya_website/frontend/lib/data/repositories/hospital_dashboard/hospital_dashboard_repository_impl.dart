// data/repositories/hospital/hospital_dashboard_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:frontend/common/paginated_result.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/data/resources/hospital_dashboard/hospital_dashboard_remote_datasource.dart';
import 'package:frontend/domain/entities/hosptial_dashboard/doctor_staff_section.dart';
import 'package:frontend/domain/entities/hosptial_dashboard/doctor_summary_entity.dart';
import 'package:frontend/domain/entities/hosptial_dashboard/hospital_metrics_entity.dart';
import 'package:frontend/domain/repositories/hospital_dashboard/hospital_dashboard_repository.dart';
import 'package:frontend/domain/usecases/hospital_dashboard/create_doctor_usecase.dart';


class HospitalDashboardRepositoryImpl implements HospitalDashboardRepository {
  final HospitalDashboardRemoteDataSource remoteDataSource;
  const HospitalDashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PaginatedResult<DoctorSummaryEntity>>> getDoctorsBySection({
    required int hospitalId,
    required DoctorStaffSection section,
    required int page,
    required int size,
  }) async {
    try {
      final result = await remoteDataSource.getDoctorsBySection(
        hospitalId: hospitalId,
        section: section,
        page: page,
        size: size,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedResult<DoctorSummaryEntity>>> searchDoctorsByQuery({
    required int hospitalId,
    required DoctorStaffSection section,
    required String query,
    required int page,
    required int size,
  }) async {
    try {
      final result = await remoteDataSource.searchDoctorsByQuery(
        hospitalId: hospitalId,
        section: section,
        query: query,
        page: page,
        size: size,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedResult<DoctorSummaryEntity>>> filterDoctorsBySpecialization({
    required int hospitalId,
    required DoctorStaffSection section,
    required String specialization,
    required int page,
    required int size,
  }) async {
    try {
      final result = await remoteDataSource.filterDoctorsBySpecialization(
        hospitalId: hospitalId,
        section: section,
        specialization: specialization,
        page: page,
        size: size,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getSpecializations({required int hospitalId}) async {
    try {
      final result = await remoteDataSource.getSpecializations(hospitalId: hospitalId);
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, HospitalMetricsEntity>> getMetrics({required int hospitalId}) async {
    try {
      final result = await remoteDataSource.getMetrics(hospitalId: hospitalId);
      return Right(result);
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
      return const NetworkFailure('Unable to reach the server. Check your connection.');
    }
    final statusCode = e.response?.statusCode;
    if (statusCode == 401 || statusCode == 403) {
      return const AuthFailure('Not authorized.');
    }
    final backendMessage =
        e.response?.data is Map ? (e.response?.data['message'] as String?) : null;
    return ServerFailure(backendMessage ?? 'Something went wrong. Please try again.');
  }


  @override
Future<Either<Failure, Unit>> createDoctor({required CreateDoctorParams params}) async {
  try {
    await remoteDataSource.createDoctor(params: params);
    return const Right(unit);
  } on DioException catch (e) {
    return Left(_mapDioError(e));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}
}