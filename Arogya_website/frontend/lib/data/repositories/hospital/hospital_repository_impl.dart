import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/data/resources/hospital/hospital_remote_datasource.dart';
import 'package:frontend/domain/entities/auth/hospital.dart';
import 'package:frontend/domain/repositories/hospital/hospital_repository.dart';

class HospitalRepositoryImpl implements HospitalRepository {
  final HospitalRemoteDataSource remoteDataSource;
  HospitalRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Hospital>>> searchHospitals(String query) async {
    try {
      final result = await remoteDataSource.searchHospitals(query);
      return Right(result);
} on DioException catch (e) {
  print("DIO ERROR TYPE: ${e.type}");
  print("DIO ERROR MESSAGE: ${e.message}");
  print("DIO ERROR UNDERLYING: ${e.error}");
  print("DIO ERROR STACK: ${e.stackTrace}");
  return Left(ServerFailure(e.response?.data?['message'] ?? 'Search failed'));
} catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}