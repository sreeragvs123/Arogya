import 'package:dio/dio.dart';
import 'package:frontend/common/paginated_result_model.dart';
import 'package:frontend/core/network/api_routes.dart';
import 'package:frontend/data/models/hospital_staff/staff_summary_model.dart';
import 'package:frontend/domain/entities/hospital_staff/staff_entities.dart';

abstract class StaffRemoteDataSource {
  Future<void> createStaff(CreateStaffParams params);
Future<PaginatedResultModel<StaffSummaryModel>> getStaff({
  required int page,
  required int size,
});
}

class StaffRemoteDataSourceImpl implements StaffRemoteDataSource {
  final Dio dio;
  StaffRemoteDataSourceImpl(this.dio);

  Map<String, dynamic> _unwrap(dynamic responseData) {
    final envelope = responseData as Map<String, dynamic>;
    if (envelope['error'] != null) {
      final error = envelope['error'] as Map<String, dynamic>;
      throw Exception(error['message'] as String? ?? 'Request failed');
    }
    return envelope['data'] is Map<String, dynamic>
        ? envelope['data'] as Map<String, dynamic>
        : {'content': envelope['data']};
  }

@override
Future<PaginatedResultModel<StaffSummaryModel>> getStaff({
  required int page,
  required int size,
}) async {
  final res = await dio.get(
    ApiRoutes.getAllStaff,
    queryParameters: {'page': page, 'size': size},
  );
  return PaginatedResultModel.fromJson(
    _unwrap(res.data),
    StaffSummaryModel.fromJson,
  );
}

  @override
  Future<void> createStaff(CreateStaffParams params) async {
    final res = await dio.post(
      ApiRoutes.staffCreate,
      data: params.toJson(),
    );
    final envelope = res.data as Map<String, dynamic>;
    if (envelope['error'] != null) {
      final error = envelope['error'] as Map<String, dynamic>;
      throw Exception(error['message'] as String? ?? 'Request failed');
    }
  }
}