import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/patient_model.dart';
import '../models/hospital_model.dart';

/// Base URL — change to your Spring Boot server address
const String _baseUrl = 'http://localhost:8080/api';

/// Centralised API service for all backend calls.
/// Every method returns the parsed model or throws an [ApiException].
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _authToken;

  void setToken(String token) => _authToken = token;
  void clearToken() => _authToken = null;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  // ── Generic helpers ─────────────────────────────────────────────────────────

  Future<dynamic> _get(String path) async {
    final res = await http.get(Uri.parse('$_baseUrl$path'), headers: _headers);
    return _handle(res);
  }

  Future<dynamic> _post(String path, Map<String, dynamic> body) async {
    final res = await http.post(Uri.parse('$_baseUrl$path'), headers: _headers, body: jsonEncode(body));
    return _handle(res);
  }

  Future<dynamic> _put(String path, Map<String, dynamic> body) async {
    final res = await http.put(Uri.parse('$_baseUrl$path'), headers: _headers, body: jsonEncode(body));
    return _handle(res);
  }

  Future<void> _delete(String path) async {
    final res = await http.delete(Uri.parse('$_baseUrl$path'), headers: _headers);
    _handle(res);
  }

  dynamic _handle(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return null;
      return jsonDecode(res.body);
    }
    final msg = _tryParseError(res.body) ?? 'Server error (${res.statusCode})';
    throw ApiException(res.statusCode, msg);
  }

  String? _tryParseError(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      return json['message'] as String?;
    } catch (_) {
      return null;
    }
  }

  // ── Hospital ─────────────────────────────────────────────────────────────────

  /// Register a new hospital. Returns the created [HospitalModel].
  Future<HospitalModel> registerHospital(Map<String, dynamic> data) async {
    final json = await _post('/hospitals/register', data);
    return HospitalModel.fromJson(json as Map<String, dynamic>);
  }

  /// Fetch details of the currently logged-in hospital.
  Future<HospitalModel> getHospital(String hospitalId) async {
    final json = await _get('/hospitals/$hospitalId');
    return HospitalModel.fromJson(json as Map<String, dynamic>);
  }

  // ── Departments ───────────────────────────────────────────────────────────────

  Future<List<DepartmentModel>> getDepartments(String hospitalId) async {
    final json = await _get('/hospitals/$hospitalId/departments') as List<dynamic>;
    return json.map((e) => DepartmentModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<DepartmentModel> addDepartment(String hospitalId, Map<String, dynamic> data) async {
    final json = await _post('/hospitals/$hospitalId/departments', data);
    return DepartmentModel.fromJson(json as Map<String, dynamic>);
  }

  Future<DepartmentModel> updateDepartment(String hospitalId, String deptId, Map<String, dynamic> data) async {
    final json = await _put('/hospitals/$hospitalId/departments/$deptId', data);
    return DepartmentModel.fromJson(json as Map<String, dynamic>);
  }

  Future<void> deleteDepartment(String hospitalId, String deptId) =>
      _delete('/hospitals/$hospitalId/departments/$deptId');

  // ── Doctors ───────────────────────────────────────────────────────────────────

  Future<List<DoctorModel>> getDoctors(String hospitalId, String deptId) async {
    final json = await _get('/hospitals/$hospitalId/departments/$deptId/doctors') as List<dynamic>;
    return json.map((e) => DoctorModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<DoctorModel> addDoctor(String hospitalId, String deptId, Map<String, dynamic> data) async {
    final json = await _post('/hospitals/$hospitalId/departments/$deptId/doctors', data);
    return DoctorModel.fromJson(json as Map<String, dynamic>);
  }

  Future<DoctorModel> updateDoctor(String hospitalId, String deptId, String doctorId, Map<String, dynamic> data) async {
    final json = await _put('/hospitals/$hospitalId/departments/$deptId/doctors/$doctorId', data);
    return DoctorModel.fromJson(json as Map<String, dynamic>);
  }

  Future<void> deleteDoctor(String hospitalId, String deptId, String doctorId) =>
      _delete('/hospitals/$hospitalId/departments/$deptId/doctors/$doctorId');

  // ── Patients ──────────────────────────────────────────────────────────────────

  Future<List<PatientModel>> getPatients(String hospitalId, String doctorId) async {
    final json = await _get('/hospitals/$hospitalId/doctors/$doctorId/patients') as List<dynamic>;
    return json.map((e) => PatientModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Register a new patient and get back the full model including generated ID.
  Future<PatientModel> registerPatient(String hospitalId, Map<String, dynamic> data) async {
    final json = await _post('/hospitals/$hospitalId/patients/register', data);
    return PatientModel.fromJson(json as Map<String, dynamic>);
  }

  /// Look up a patient by their unique ID (e.g. AY001234).
  Future<PatientModel> getPatientById(String patientId) async {
    final json = await _get('/patients/$patientId');
    return PatientModel.fromJson(json as Map<String, dynamic>);
  }

  /// Scan QR and return the matching patient.
  Future<PatientModel> scanQrCode(String qrData) async {
    final json = await _post('/patients/scan-qr', {'qrData': qrData});
    return PatientModel.fromJson(json as Map<String, dynamic>);
  }

  // ── Checkup Receipts ──────────────────────────────────────────────────────────

  Future<CheckupReceiptModel> createReceipt(Map<String, dynamic> data) async {
    final json = await _post('/receipts', data);
    return CheckupReceiptModel.fromJson(json as Map<String, dynamic>);
  }

  Future<List<CheckupReceiptModel>> getReceiptsForPatient(String patientId) async {
    final json = await _get('/patients/$patientId/receipts') as List<dynamic>;
    return json.map((e) => CheckupReceiptModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<CheckupReceiptModel> getReceiptById(String receiptId) async {
    final json = await _get('/receipts/$receiptId');
    return CheckupReceiptModel.fromJson(json as Map<String, dynamic>);
  }

  // ── Inventory ─────────────────────────────────────────────────────────────────

  Future<List<MedicineStockModel>> getInventory(String hospitalId) async {
    final json = await _get('/hospitals/$hospitalId/inventory') as List<dynamic>;
    return json.map((e) => MedicineStockModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<MedicineStockModel> addMedicine(String hospitalId, Map<String, dynamic> data) async {
    final json = await _post('/hospitals/$hospitalId/inventory', data);
    return MedicineStockModel.fromJson(json as Map<String, dynamic>);
  }

  Future<MedicineStockModel> updateMedicine(String hospitalId, String medicineId, Map<String, dynamic> data) async {
    final json = await _put('/hospitals/$hospitalId/inventory/$medicineId', data);
    return MedicineStockModel.fromJson(json as Map<String, dynamic>);
  }

  Future<MedicineStockModel> restockMedicine(String hospitalId, String medicineId, int unitsToAdd) async {
    final json = await _post('/hospitals/$hospitalId/inventory/$medicineId/restock', {'unitsToAdd': unitsToAdd});
    return MedicineStockModel.fromJson(json as Map<String, dynamic>);
  }

  Future<void> deleteMedicine(String hospitalId, String medicineId) =>
      _delete('/hospitals/$hospitalId/inventory/$medicineId');

  // ── File upload ───────────────────────────────────────────────────────────────

  /// Upload a scan report or image. Returns the stored file URL.
  Future<String> uploadFile(String hospitalId, String patientId, List<int> bytes, String filename) async {
    final uri = Uri.parse('$_baseUrl/hospitals/$hospitalId/patients/$patientId/files');
    final req = http.MultipartRequest('POST', uri)
      ..headers.addAll({'Authorization': 'Bearer $_authToken'})
      ..files.add(http.MultipartFile.fromBytes('file', bytes, filename: filename));
    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);
    final json = _handle(res) as Map<String, dynamic>;
    return json['url'] as String;
  }
}

// ── ApiException ──────────────────────────────────────────────────────────────
class ApiException implements Exception {
  final int statusCode;
  final String message;
  const ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
