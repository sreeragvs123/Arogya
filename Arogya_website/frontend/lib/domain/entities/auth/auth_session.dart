import 'package:equatable/equatable.dart';

enum UserRole {
  doctor,
  hospitalAdmin;

  String toJson() {
    switch (this) {
      case UserRole.doctor:
        return 'DOCTOR';
      case UserRole.hospitalAdmin:
        return 'ADMIN';
    }
  }

  static UserRole fromJson(String value) {
    switch (value.toUpperCase()) {
      case 'DOCTOR':
        return UserRole.doctor;
      case 'HOSPITAL':
        return UserRole.hospitalAdmin;
      default:
        throw FormatException('Unknown role: $value');
    }
  }
}

sealed class AuthSession extends Equatable {
  final String accessToken;
  final DateTime expiresAt;
  final UserRole role;

  const AuthSession({
    required this.accessToken,
    required this.expiresAt,
    required this.role,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

class HospitalAdminSession extends AuthSession {
  final int hospitalId;
  final String hospitalName;
  final String hospitalCode;
  final String adminName;
  final String adminDesignation;

  const HospitalAdminSession({
    required super.accessToken,
    required super.role,
    required super.expiresAt,
    required this.hospitalId,
    required this.hospitalName,
    required this.hospitalCode,
    required this.adminName,
    required this.adminDesignation,
  });

  @override
  List<Object?> get props => [
    accessToken,
    expiresAt,
    role,
    hospitalId,
    hospitalName,
    hospitalCode,
    adminName,
    adminDesignation,
  ];
}

class DoctorSession extends AuthSession {
  final int? doctorId;

  const DoctorSession({
    required super.accessToken,
    required super.expiresAt,
    required super.role,
    required this.doctorId,
  });

  @override
  List<Object?> get props => [accessToken, expiresAt, role, doctorId];
}
