import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/domain/entities/auth/hospital.dart';
import 'package:frontend/domain/repositories/hospital/hospital_repository.dart';

class SearchHospitalParams {
  final String query;
  const SearchHospitalParams({required this.query});
}

class SearchHospitalUsecase extends Usecase<List<Hospital>, SearchHospitalParams> {
  final HospitalRepository repository;
  SearchHospitalUsecase(this.repository);

  @override
  Future<Either<Failure, List<Hospital>>> call({required SearchHospitalParams params}) {
    print("search usecase is called");
    return repository.searchHospitals(params.query);
  }
}