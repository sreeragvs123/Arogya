import 'package:dio/dio.dart';
import 'package:frontend/common/paginated_result_model.dart';
import 'package:frontend/core/network/api_routes.dart';
import 'package:frontend/data/models/patients/patient_summary_model.dart';
import 'package:frontend/domain/usecases/patients/get_patients_directory_summary_usecase.dart';

abstract class PatientsRemoteDataSource {
  Future<PatientsDirectorySummaryModel> getDirectorySummary(DoctorHospitalParam param);

  Future<PatientSummaryModel?> getActivePatient();

  Future<PaginatedResultModel<PatientSummaryModel>> getPatients({
    required String query,
    required String sortBy,
    required String condition,
    required int page,
    required int size,
  });

  Future<PatientSummaryModel> lookupPatient({required String identifier});
}

class PatientsRemoteDataSourceImpl implements PatientsRemoteDataSource {
  final Dio dio;
  PatientsRemoteDataSourceImpl({required this.dio});

  dynamic _unwrap(dynamic responseData) {
    final envelope = responseData as Map<String, dynamic>;
    if (envelope['error'] != null) {
      final error = envelope['error'] as Map<String, dynamic>;
      throw Exception(error['message'] as String? ?? 'Request failed');
    }
    return envelope['data'];
  }

  @override
  Future<PatientsDirectorySummaryModel> getDirectorySummary(DoctorHospitalParam param) async {
    int doctorId = param.doctorId;
    int hospitalId = param.hospitalId;
    final response = await dio.get(ApiRoutes.doctorPatientsSummary(doctorId,hospitalId));
    return PatientsDirectorySummaryModel.fromJson(_unwrap(response.data) as Map<String, dynamic>);
  }

  @override
  Future<PatientSummaryModel?> getActivePatient() async {
    final response = await dio.get(ApiRoutes.doctorPatientsActive);
    final data = _unwrap(response.data);
    if (data == null) return null;
    return PatientSummaryModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<PaginatedResultModel<PatientSummaryModel>> getPatients({
    required String query,
    required String sortBy,
    required String condition,
    required int page,
    required int size,
  }) async {
    final response = await dio.get(
      ApiRoutes.doctorPatients,
      queryParameters: {
        if (query.isNotEmpty) 'query': query,
        'sortBy': sortBy,
        if (condition != 'All Conditions') 'condition': condition,
        'page': page,
        'size': size,
      },
    );
    return PaginatedResultModel.fromJson(
      _unwrap(response.data) as Map<String, dynamic>,
      PatientSummaryModel.fromJson,
    );
  }

  @override
  Future<PatientSummaryModel> lookupPatient({required String identifier}) async {
    final response = await dio.get(
      ApiRoutes.patientLookup,
      queryParameters: {'identifier': identifier},
    );
    return PatientSummaryModel.fromJson(_unwrap(response.data) as Map<String, dynamic>);
  }
}
