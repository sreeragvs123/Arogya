import 'package:frontend/domain/entities/auth/auth_session.dart';

class HospitalSignInResponseModel extends HospitalAdminSession {
  const HospitalSignInResponseModel({
    required super.accessToken,
    required super.expiresAt,
    required super.role,
    required super.hospitalId,
    required super.hospitalName,
    required super.hospitalCode,
    required super.adminName,
    required super.adminDesignation,
  });

  factory HospitalSignInResponseModel.fromJson(Map<String, dynamic> json) {
    return HospitalSignInResponseModel(
      accessToken: json['accessToken'] as String,
      expiresAt: DateTime.now().add(const Duration(minutes: 15)),
      role: UserRole.hospitalAdmin,
      hospitalId: json['hospitalId'] as int,
      hospitalName: json['hospitalName'] as String,
      hospitalCode: json['hospitalCode'] as String,
      adminName: json['adminName'] as String,
      adminDesignation: json['adminDesignation'] as String,
    );
  }
}