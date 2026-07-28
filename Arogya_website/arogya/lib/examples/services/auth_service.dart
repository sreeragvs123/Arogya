import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

const String _baseUrl = 'http://localhost:8080/api';

/// Handles hospital login, registration, token storage, and session state.
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _api = ApiService();

  String? _token;
  String? _hospitalId;
  String? _hospitalName;

  bool get isLoggedIn => _token != null;
  String? get hospitalId => _hospitalId;
  String? get hospitalName => _hospitalName;
  String? get token => _token;

  // ── Login ────────────────────────────────────────────────────────────────────

  /// Logs in the hospital with [username] and [password].
  /// Stores the JWT token and hospital info on success.
  Future<AuthResult> login(String username, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/auth/hospital/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        _token = json['token'] as String?;
        _hospitalId = json['hospitalId'] as String?;
        _hospitalName = json['hospitalName'] as String?;

        if (_token != null) {
          _api.setToken(_token!);
        }

        return AuthResult.success(hospitalName: _hospitalName ?? username);
      }

      final msg = _parseError(res.body) ?? 'Invalid username or password.';
      return AuthResult.failure(msg);
    } catch (e) {
      return AuthResult.failure('Could not connect to server. Check your connection.');
    }
  }

  // ── Register ─────────────────────────────────────────────────────────────────

  /// Registers a new hospital.
  /// On success, auto-logs in and returns [AuthResult.success].
  Future<AuthResult> register({
    required String hospitalName,
    required String registrationNumber,
    required String type,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String state,
    required String pincode,
    required String username,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/auth/hospital/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': hospitalName,
          'registrationNumber': registrationNumber,
          'type': type,
          'email': email,
          'phone': phone,
          'address': address,
          'city': city,
          'state': state,
          'pincode': pincode,
          'username': username,
          'password': password,
        }),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        // Auto-login after registration
        return login(username, password);
      }

      final msg = _parseError(res.body) ?? 'Registration failed. Try again.';
      return AuthResult.failure(msg);
    } catch (e) {
      return AuthResult.failure('Could not connect to server. Check your connection.');
    }
  }

  // ── Patient login (for app — web hospitals don't use this) ───────────────────

  /// Used by the Flutter patient app to verify patient credentials.
  Future<AuthResult> patientLogin(String username, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/auth/patient/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        _token = json['token'] as String?;
        if (_token != null) _api.setToken(_token!);
        return AuthResult.success(hospitalName: json['patientName'] ?? '');
      }

      final msg = _parseError(res.body) ?? 'Invalid credentials.';
      return AuthResult.failure(msg);
    } catch (e) {
      return AuthResult.failure('Could not connect to server.');
    }
  }

  // ── Logout ───────────────────────────────────────────────────────────────────

  void logout() {
    _token = null;
    _hospitalId = null;
    _hospitalName = null;
    _api.clearToken();
  }

  // ── Token refresh ─────────────────────────────────────────────────────────────

  Future<bool> refreshToken() async {
    if (_token == null) return false;
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/auth/refresh'),
        headers: {'Authorization': 'Bearer $_token', 'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        _token = json['token'] as String?;
        if (_token != null) _api.setToken(_token!);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────────

  String? _parseError(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      return json['message'] as String?;
    } catch (_) {
      return null;
    }
  }
}

// ── AuthResult ────────────────────────────────────────────────────────────────
class AuthResult {
  final bool success;
  final String? hospitalName;
  final String? error;

  const AuthResult._({required this.success, this.hospitalName, this.error});

  factory AuthResult.success({required String hospitalName}) =>
      AuthResult._(success: true, hospitalName: hospitalName);

  factory AuthResult.failure(String error) =>
      AuthResult._(success: false, error: error);
}
