import 'package:dartz/dartz.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/domain/entities/doctor_dashboard/activity_entity.dart';
import 'package:frontend/domain/repositories/doctor_dashboard/doctor_dashboard_repository.dart';

class GetRecentActivityParams {
  final int limit;
  const GetRecentActivityParams({this.limit = 10});
}

class GetRecentActivityUsecase extends Usecase<List<ActivityEntity>, GetRecentActivityParams> {
  final DoctorDashboardRepository repository;
  GetRecentActivityUsecase(this.repository);

  @override
  Future<Either<Failure, List<ActivityEntity>>> call({
    required GetRecentActivityParams params,
  }) {
    return repository.getRecentActivity(limit: params.limit);
  }
}
