import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_routes.dart';
import 'package:frontend/data/models/doctor_dashboard/activity_model.dart';
import 'package:frontend/data/models/doctor_dashboard/consultation_model.dart';
import 'package:frontend/data/models/doctor_dashboard/dashboard_summary_model.dart';

abstract class DoctorDashboardRemoteDataSource {
  Future<DashboardSummaryModel> getDashboardSummary();

  Future<List<ConsultationModel>> getUpcomingConsultations();

  Future<List<ActivityModel>> getRecentActivity({int limit = 10});

  Future<void> startConsultation({required String consultationId});

  Future<void> joinConsultationCall({required String consultationId});
}

class DoctorDashboardRemoteDataSourceImpl implements DoctorDashboardRemoteDataSource {
  final Dio dio;
  DoctorDashboardRemoteDataSourceImpl({required this.dio});

  /// Unwraps the backend's ApiResponse<T> envelope: { timestamp, data, error }.
  dynamic _unwrap(dynamic responseData) {
    final envelope = responseData as Map<String, dynamic>;
    if (envelope['error'] != null) {
      final error = envelope['error'] as Map<String, dynamic>;
      throw Exception(error['message'] as String? ?? 'Request failed');
    }
    return envelope['data'];
  }

  @override
  Future<DashboardSummaryModel> getDashboardSummary() async {
    final response = await dio.get(ApiRoutes.doctorDashboardSummary);
    return DashboardSummaryModel.fromJson(_unwrap(response.data) as Map<String, dynamic>);
  }

  @override
  Future<List<ConsultationModel>> getUpcomingConsultations() async {
    final response = await dio.get(ApiRoutes.doctorDashboardConsultations);
    final data = _unwrap(response.data) as List;
    return data.map((e) => ConsultationModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<ActivityModel>> getRecentActivity({int limit = 10}) async {
    final response = await dio.get(
      ApiRoutes.doctorDashboardActivity,
      queryParameters: {'limit': limit},
    );
    final data = _unwrap(response.data) as List;
    return data.map((e) => ActivityModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> startConsultation({required String consultationId}) async {
    final response = await dio.post(ApiRoutes.consultationStart(consultationId));
    _unwrap(response.data);
  }

  @override
  Future<void> joinConsultationCall({required String consultationId}) async {
    final response = await dio.post(ApiRoutes.consultationJoinCall(consultationId));
    _unwrap(response.data);
  }
}
