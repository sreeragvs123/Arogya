import 'package:equatable/equatable.dart';

enum UserRole {
  doctor,
  hospitalAdmin,
  staff;

  String toJson() {
    switch (this) {
      case UserRole.doctor:
        return 'DOCTOR';
      case UserRole.hospitalAdmin:
        return 'ADMIN';
      case UserRole.staff:
        return 'STAFF';
    }
  }

  static UserRole fromJson(String value) {
    switch (value.toUpperCase()) {
      case 'DOCTOR':
        return UserRole.doctor;
      case 'ADMIN':
        return UserRole.hospitalAdmin;
      case 'STAFF':
        return UserRole.staff;
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

  Map<String, dynamic> toJson();

  static AuthSession fromJson(Map<String, dynamic> json) {
    final role = UserRole.fromJson(json['role'] as String);
    switch (role) {
      case UserRole.doctor:
        return DoctorSession.fromJson(json);
      case UserRole.hospitalAdmin:
        return HospitalAdminSession.fromJson(json);
      case UserRole.staff:
        return StaffSession.fromJson(json);
    }
  }
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
  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'expiresAt': expiresAt.toIso8601String(),
    'role': role.toJson(),
    'hospitalId': hospitalId,
    'hospitalName': hospitalName,
    'hospitalCode': hospitalCode,
    'adminName': adminName,
    'adminDesignation': adminDesignation,
  };

  factory HospitalAdminSession.fromJson(Map<String, dynamic> json) {
    return HospitalAdminSession(
      accessToken: json['accessToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      role: UserRole.fromJson(json['role'] as String),
      hospitalId: json['hospitalId'] as int,
      hospitalName: json['hospitalName'] as String,
      hospitalCode: json['hospitalCode'] as String,
      adminName: json['adminName'] as String,
      adminDesignation: json['adminDesignation'] as String,
    );
  }

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
  final String doctorName;
  final int? hospitalId;

  const DoctorSession({
    required this.hospitalId,
    required super.accessToken,
    required super.expiresAt,
    required super.role,
    required this.doctorId,
    required this.doctorName,
  });

  @override
  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'expiresAt': expiresAt.toIso8601String(),
    'role': role.toJson(),
    'doctorId': doctorId,
    'doctorName': doctorName,
    'hospitalId': hospitalId,
  };

  factory DoctorSession.fromJson(Map<String, dynamic> json) {
    return DoctorSession(
      accessToken: json['accessToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      role: UserRole.fromJson(json['role'] as String),
      doctorId: json['doctorId'] as int?,
      doctorName: json['doctorName'] as String,
      hospitalId: json['hospitalId'] as int?,
    );
  }

  @override
  List<Object?> get props => [
    accessToken,
    expiresAt,
    role,
    doctorId,
    doctorName,
    hospitalId,
  ];
}

class StaffSession extends AuthSession {
  final int? staffId;
  final String staffName;
  final int? hospitalId;
  final String department;

  const StaffSession({
    required super.accessToken,
    required super.expiresAt,
    required super.role,
    required this.staffId,
    required this.staffName,
    required this.hospitalId,
    required this.department,
  });

  @override
  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'expiresAt': expiresAt.toIso8601String(),
    'role': role.toJson(),
    'staffId': staffId,
    'staffName': staffName,
    'hospitalId': hospitalId,
    'department': department,
  };

  factory StaffSession.fromJson(Map<String, dynamic> json) {
    return StaffSession(
      accessToken: json['accessToken'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      role: UserRole.fromJson(json['role'] as String),
      staffId: json['staffId'] as int?,
      staffName: json['staffName'] as String,
      hospitalId: json['hospitalId'] as int?,
      department: json['department'] as String,
    );
  }

  @override
  List<Object?> get props => [
    accessToken,
    expiresAt,
    role,
    staffId,
    staffName,
    hospitalId,
    department,
  ];
}
