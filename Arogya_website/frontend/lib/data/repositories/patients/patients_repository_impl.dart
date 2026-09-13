import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:frontend/common/paginated_result.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/data/resources/patients/patients_remote_datasource.dart';
import 'package:frontend/domain/entities/patients/patient_summary_entity.dart';
import 'package:frontend/domain/repositories/patients/patients_repository.dart';

class PatientsRepositoryImpl implements PatientsRepository {
  final PatientsRemoteDataSource remoteDataSource;
  const PatientsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PatientsDirectorySummaryEntity>> getDirectorySummary() async {
    try {
      final result = await remoteDataSource.getDirectorySummary();
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PatientSummaryEntity?>> getActivePatient() async {
    try {
      final result = await remoteDataSource.getActivePatient();
      return Right(result);
    } on DioException catch (e) {
      // A 404 here just means "no active patient right now" — not an error.
      if (e.response?.statusCode == 404) return const Right(null);
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedResult<PatientSummaryEntity>>> getPatients({
    required String query,
    required String sortBy,
    required String condition,
    required int page,
    required int size,
  }) async {
    try {
      final result = await remoteDataSource.getPatients(
        query: query,
        sortBy: sortBy,
        condition: condition,
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
  Future<Either<Failure, PatientSummaryEntity>> lookupPatient({
    required String identifier,
  }) async {
    try {
      final result = await remoteDataSource.lookupPatient(identifier: identifier);
      return Right(result);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const Left(ServerFailure('No patient found for that ID. Double-check and try again.'));
      }
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
}
