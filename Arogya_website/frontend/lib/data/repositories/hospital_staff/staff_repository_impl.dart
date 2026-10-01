import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:frontend/common/paginated_result.dart';
import 'package:frontend/core/error/failures.dart'; 
import 'package:frontend/data/resources/hospital_staff/staff_remote_datasource.dart';
import 'package:frontend/domain/entities/hospital_staff/staff_entities.dart';
import 'package:frontend/domain/repositories/hospital_staff/staff_repository.dart';

class StaffRepositoryImpl implements StaffRepository {
  final StaffRemoteDataSource remote;
  StaffRepositoryImpl(this.remote);

@override
Future<Either<Failure, PaginatedResult<StaffSummaryEntity>>> getStaff({
  required int page,
  required int size,
}) async {
  try {
    return Right(await remote.getStaff(page: page, size: size));
  } on DioException catch (e) {
    return Left(_toFailure(e));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}

  @override
  Future<Either<Failure, void>> createStaff(CreateStaffParams params) async {
    try {
      await remote.createStaff(params);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_toFailure(e));
    } catch (_) {
      return Left(ServerFailure('Something went wrong. Please try again.')); // TODO
    }
  }

  Failure _toFailure(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const NetworkFailure('Unable to reach the server. Check your connection.');
    }

    final status = e.response?.statusCode;
    final body = e.response?.data;
    final message = (body is Map && body['message'] is String)
        ? body['message'] as String
        : 'Request failed (${status ?? 'unknown'})';

    if (status == 401 || status == 403) {
      return AuthFailure(message);
    }
    return ServerFailure(message);
  }
}