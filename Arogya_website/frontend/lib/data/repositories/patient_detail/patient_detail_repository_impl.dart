import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/data/models/patient_detail/patient_detail_model.dart';
import 'package:frontend/data/resources/patient_detail/patient_detail_remote_datasource.dart';
import 'package:frontend/domain/entities/patient_detail/patient_detail_entity.dart';
import 'package:frontend/domain/repositories/patient_detail/patient_detail_repository.dart';

class PatientDetailRepositoryImpl implements PatientDetailRepository {
  final PatientDetailRemoteDataSource remoteDataSource;
  const PatientDetailRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PatientDetailEntity>> getPatientDetail({
    required String patientId,
  }) async {
    try {
      return Right(await remoteDataSource.getPatientDetail(patientId: patientId));
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VitalsEntity>> getVitals({required String patientId}) async {
    try {
      return Right(await remoteDataSource.getVitals(patientId: patientId));
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ObservationEntity>>> getRecentObservations({
    required String patientId,
  }) async {
    try {
      return Right(await remoteDataSource.getRecentObservations(patientId: patientId));
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VitalsEntity>> updateVitals({
    required String patientId,
    required VitalsUpdateInput input,
  }) async {
    try {
      return Right(await remoteDataSource.updateVitals(patientId: patientId, input: input));
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveObservations({
    required String patientId,
    required List<String> symptoms,
    required String clinicalNote,
  }) async {
    try {
      await remoteDataSource.saveObservations(
        patientId: patientId,
        symptoms: symptoms,
        clinicalNote: clinicalNote,
      );
      return const Right(unit);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PrescriptionItemEntity>>> getPrescriptionDraft({
    required String patientId,
  }) async {
    try {
      return Right(await remoteDataSource.getPrescriptionDraft(patientId: patientId));
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> savePrescription({
    required String patientId,
    required List<PrescriptionItemEntity> items,
  }) async {
    try {
      final models = items
          .map((e) => PrescriptionItemModel(
                id: e.id,
                name: e.name,
                dosage: e.dosage,
                frequency: e.frequency,
                timing: e.timing,
              ))
          .toList();
      await remoteDataSource.savePrescription(patientId: patientId, items: models);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ClinicalReportEntity>> generateClinicalReport({
    required String patientId,
  }) async {
    try {
      return Right(await remoteDataSource.generateClinicalReport(patientId: patientId));
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
}
