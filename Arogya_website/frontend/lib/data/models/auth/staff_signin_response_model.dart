import 'package:frontend/domain/entities/auth/auth_session.dart';

class StaffSignInResponseModel extends StaffSession {
  const StaffSignInResponseModel({
    required super.accessToken,
    required super.expiresAt,
    required super.role,
    required super.staffId,
    required super.staffName,
    required super.hospitalId,
    required super.department,
  });

  factory StaffSignInResponseModel.fromJson(Map<String, dynamic> json) {
    return StaffSignInResponseModel(
      accessToken: json['accessToken'] as String,
      expiresAt: DateTime.now().add(const Duration(minutes: 15)),
      role: UserRole.fromJson(json['role']),
      staffId: json['staffId'] as int?,
      staffName: json['staffName'] as String,
      hospitalId: json['hospitalId'] as int?,
      department: json['department'] as String,
    );
  }
}