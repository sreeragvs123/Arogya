// data/resources/hospital/hospital_dashboard_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:frontend/common/paginated_result_model.dart';
import 'package:frontend/core/network/api_routes.dart';
import 'package:frontend/data/models/hospital_dashboard/doctor_detail_model.dart';
import 'package:frontend/data/models/hospital_dashboard/doctor_summary_model.dart';
import 'package:frontend/data/models/hospital_dashboard/hospital_metrics_model.dart';

import 'package:frontend/domain/entities/hosptial_dashboard/doctor_staff_section.dart';
import 'package:frontend/domain/usecases/hospital_dashboard/create_doctor_usecase.dart';

abstract class HospitalDashboardRemoteDataSource {
  // abstract class HospitalDashboardRemoteDataSource
  Future<void> createDoctor({required CreateDoctorParams params});

  Future<PaginatedResultModel<DoctorSummaryModel>> getDoctorsBySection({
    required int hospitalId,
    required DoctorStaffSection section,
    required int page,
    required int size,
  });

  Future<DoctorDetailModel> getDoctorDetail({
  required int hospitalId,
  required int doctorId,
});

  Future<PaginatedResultModel<DoctorSummaryModel>> searchDoctorsByQuery({
    required int hospitalId,
    required DoctorStaffSection section,
    required String query,
    required int page,
    required int size,
  });

  Future<PaginatedResultModel<DoctorSummaryModel>>
  filterDoctorsBySpecialization({
    required int hospitalId,
    required DoctorStaffSection section,
    required String specialization,
    required int page,
    required int size,
  });

  Future<List<String>> getSpecializations({required int hospitalId});

  Future<HospitalMetricsModel> getMetrics({required int hospitalId});
}

class HospitalDashboardRemoteDataSourceImpl
    implements HospitalDashboardRemoteDataSource {
  final Dio dio;
  HospitalDashboardRemoteDataSourceImpl({required this.dio});


  Map<String, dynamic> _unwrap(dynamic responseData) {
    final envelope = responseData as Map<String, dynamic>;
    if (envelope['error'] != null) {
      final error = envelope['error'] as Map<String, dynamic>;
      throw Exception(error['message'] as String? ?? 'Request failed');
    }
    return envelope['data'] as Map<String, dynamic>;
  }

  @override
Future<DoctorDetailModel> getDoctorDetail({
  required int hospitalId,
  required int doctorId,
}) async {
  final response = await dio.get(
    ApiRoutes.hospitalDoctorDetail(hospitalId, doctorId),
  );
  return DoctorDetailModel.fromJson(_unwrap(response.data));
}

  @override
  Future<PaginatedResultModel<DoctorSummaryModel>> getDoctorsBySection({
    required int hospitalId,
    required DoctorStaffSection section,
    required int page,
    required int size,
  }) async {
    final response = await dio.get(
      ApiRoutes.hospitalDoctorsBySection(hospitalId),
      queryParameters: {
        'section': section.apiValue,
        'page': page,
        'size': size,
      },
    );
    return PaginatedResultModel.fromJson(
      _unwrap(response.data),
      DoctorSummaryModel.fromJson,
    );
  }

  @override
  Future<PaginatedResultModel<DoctorSummaryModel>> searchDoctorsByQuery({
    required int hospitalId,
    required DoctorStaffSection section,
    required String query,
    required int page,
    required int size,
  }) async {
    final response = await dio.get(
      ApiRoutes.hospitalDoctorsSearch(hospitalId),
      queryParameters: {
        'section': section.apiValue,
        'query': query,
        'page': page,
        'size': size,
      },
    );
    return PaginatedResultModel.fromJson(
      _unwrap(response.data),
      DoctorSummaryModel.fromJson,
    );
  }

  @override
  Future<PaginatedResultModel<DoctorSummaryModel>>
  filterDoctorsBySpecialization({
    required int hospitalId,
    required DoctorStaffSection section,
    required String specialization,
    required int page,
    required int size,
  }) async {
    final response = await dio.get(
      ApiRoutes.hospitalDoctorsFilterSpecialization(hospitalId),
      queryParameters: {
        'section': section.apiValue,
        'specialization': specialization,
        'page': page,
        'size': size,
      },
    );
    return PaginatedResultModel.fromJson(
      _unwrap(response.data),
      DoctorSummaryModel.fromJson,
    );
  }

  @override
  Future<List<String>> getSpecializations({required int hospitalId}) async {
    final response = await dio.get(
      ApiRoutes.hospitalDoctorsSpecializations(hospitalId),
    );
    final envelope = response.data as Map<String, dynamic>;
    if (envelope['error'] != null) {
      final error = envelope['error'] as Map<String, dynamic>;
      throw Exception(error['message'] as String? ?? 'Request failed');
    }
    final data = envelope['data'] as List;
    return data.map((e) => e as String).toList();
  }

  @override
  Future<HospitalMetricsModel> getMetrics({required int hospitalId}) async {
    final response = await dio.get(ApiRoutes.hospitalMetrics(hospitalId));
    return HospitalMetricsModel.fromJson(_unwrap(response.data));
  }

  // impl
  @override
  Future<void> createDoctor({required CreateDoctorParams params}) async {
    final response = await dio.post(
      ApiRoutes.doctorCreate(params.hospitalId),
      data: {
        'fullName': params.fullName,
        'licenseNumber': params.licenseNumber,
        'specialization': params.department,
        'designation': params.designation,
        'email': params.email,
        'phoneNumber': params.phoneNumber,
        'temporaryPin': params.temporaryPin,
        'prescriptionAuthority': params.prescriptionAuthority,
        'labImagingOrdering': params.labImagingOrdering,
        'dischargeSignoffAuthority': params.dischargeSignoffAuthority,
      },
    );

    final envelope = response.data as Map<String, dynamic>;
    if (envelope['error'] != null) {
      final error = envelope['error'] as Map<String, dynamic>;
      throw Exception(error['message'] as String? ?? 'Request failed');
    }
  }
}
