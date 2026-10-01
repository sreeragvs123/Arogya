import 'package:dartz/dartz.dart';
import 'package:frontend/common/paginated_result.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/core/usecases/usecase.dart';
import 'package:frontend/domain/entities/hospital_staff/staff_entities.dart';
import 'package:frontend/domain/repositories/hospital_staff/staff_repository.dart';

class GetStaffParams {
  final int page;
  final int size;
  const GetStaffParams({this.page = 0, this.size = 10});
}

class GetStaffUsecase
    extends Usecase<PaginatedResult<StaffSummaryEntity>, GetStaffParams> {
  final StaffRepository repository;
  GetStaffUsecase(this.repository);

  @override
  Future<Either<Failure, PaginatedResult<StaffSummaryEntity>>> call({
    required GetStaffParams params,
  }) =>
      repository.getStaff(page: params.page, size: params.size);
}

class CreateStaffUsecase extends Usecase<void, CreateStaffParams> {
  final StaffRepository repository;
  CreateStaffUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call({required CreateStaffParams params}) =>
      repository.createStaff(params);
}