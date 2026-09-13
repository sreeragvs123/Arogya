import 'package:frontend/domain/entities/auth/auth_session.dart';

class DoctorSignInResponseModel extends DoctorSession{


  const DoctorSignInResponseModel({
    required super.accessToken,
    required super.expiresAt,
    required super.role,
    required super.doctorId
  });

  factory DoctorSignInResponseModel.fromJson(Map<String, dynamic> json) {
    return DoctorSignInResponseModel(
      accessToken: json['accessToken'] as String,
      expiresAt: DateTime.now().add(const Duration(minutes: 15)),
      role: UserRole.fromJson(json["role"]),
      doctorId: json['doctorId'] as int?,
    );
  }
}
