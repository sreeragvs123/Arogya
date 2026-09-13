import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_routes.dart';
import 'package:frontend/data/models/patient_detail/patient_detail_model.dart';
import 'package:frontend/domain/repositories/patient_detail/patient_detail_repository.dart';

abstract class PatientDetailRemoteDataSource {
  Future<PatientDetailModel> getPatientDetail({required String patientId});

  Future<VitalsModel> getVitals({required String patientId});

  Future<List<ObservationModel>> getRecentObservations({required String patientId});

  Future<VitalsModel> updateVitals({
    required String patientId,
    required VitalsUpdateInput input,
  });

  Future<void> saveObservations({
    required String patientId,
    required List<String> symptoms,
    required String clinicalNote,
  });

  Future<List<PrescriptionItemModel>> getPrescriptionDraft({required String patientId});

  Future<void> savePrescription({
    required String patientId,
    required List<PrescriptionItemModel> items,
  });

  Future<ClinicalReportModel> generateClinicalReport({required String patientId});
}

class PatientDetailRemoteDataSourceImpl implements PatientDetailRemoteDataSource {
  final Dio dio;
  PatientDetailRemoteDataSourceImpl({required this.dio});

  dynamic _unwrap(dynamic responseData) {
    final envelope = responseData as Map<String, dynamic>;
    if (envelope['error'] != null) {
      final error = envelope['error'] as Map<String, dynamic>;
      throw Exception(error['message'] as String? ?? 'Request failed');
    }
    return envelope['data'];
  }

  @override
  Future<PatientDetailModel> getPatientDetail({required String patientId}) async {
    final response = await dio.get(ApiRoutes.patientDetail(patientId));
    return PatientDetailModel.fromJson(_unwrap(response.data) as Map<String, dynamic>);
  }

  @override
  Future<VitalsModel> getVitals({required String patientId}) async {
    final response = await dio.get(ApiRoutes.patientVitals(patientId));
    return VitalsModel.fromJson(_unwrap(response.data) as Map<String, dynamic>);
  }

  @override
  Future<List<ObservationModel>> getRecentObservations({required String patientId}) async {
    final response = await dio.get(ApiRoutes.patientObservations(patientId));
    final data = _unwrap(response.data) as List;
    return data.map((e) => ObservationModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<VitalsModel> updateVitals({
    required String patientId,
    required VitalsUpdateInput input,
  }) async {
    final response = await dio.post(ApiRoutes.patientVitals(patientId), data: input.toJson());
    return VitalsModel.fromJson(_unwrap(response.data) as Map<String, dynamic>);
  }

  @override
  Future<void> saveObservations({
    required String patientId,
    required List<String> symptoms,
    required String clinicalNote,
  }) async {
    final response = await dio.post(
      ApiRoutes.patientObservations(patientId),
      data: {'symptoms': symptoms, 'clinicalNote': clinicalNote},
    );
    _unwrap(response.data);
  }

  @override
  Future<List<PrescriptionItemModel>> getPrescriptionDraft({required String patientId}) async {
    final response = await dio.get(ApiRoutes.patientPrescriptionDraft(patientId));
    final data = _unwrap(response.data) as List;
    return data.map((e) => PrescriptionItemModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> savePrescription({
    required String patientId,
    required List<PrescriptionItemModel> items,
  }) async {
    final response = await dio.post(
      ApiRoutes.patientPrescriptionSave(patientId),
      data: {'items': items.map((e) => e.toJson()).toList()},
    );
    _unwrap(response.data);
  }

  @override
  Future<ClinicalReportModel> generateClinicalReport({required String patientId}) async {
    final response = await dio.post(ApiRoutes.patientClinicalReportGenerate(patientId));
    return ClinicalReportModel.fromJson(_unwrap(response.data) as Map<String, dynamic>);
  }
}
