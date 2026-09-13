import 'package:frontend/domain/entities/auth/auth_session.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required super.accessToken,
    super.refreshToken,
    required super.expiresAt,
    required super.role,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String?,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      role: _roleFromString(json['role'] as String),
    );
  }

static UserRole _roleFromString(String value) {
  switch (value.toUpperCase()) {
    case 'DOCTOR':
      return UserRole.doctor;
    case 'HOSPITAL':          // ← now matches backend's Role.HOSPITAL
      return UserRole.hospitalAdmin;
    default:
      throw FormatException('Unknown role: $value');
  }
}

}