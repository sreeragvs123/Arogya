import 'package:dartz/dartz.dart';
import 'package:frontend/common/paginated_result.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/domain/entities/hospital_staff/staff_entities.dart';

abstract class StaffRepository {
  Future<Either<Failure, PaginatedResult<StaffSummaryEntity>>> getStaff({
  required int page,
  required int size,
});
  Future<Either<Failure, void>> createStaff(CreateStaffParams params);
}