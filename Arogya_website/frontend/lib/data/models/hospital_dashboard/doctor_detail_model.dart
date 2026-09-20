import 'package:frontend/domain/entities/hosptial_dashboard/doctor_detail_entity.dart';
import 'package:frontend/domain/entities/hosptial_dashboard/doctor_summary_entity.dart';

class DoctorDetailModel extends DoctorDetailEntity {
  const DoctorDetailModel({
    required super.doctorId,
    required super.fullName,
    super.profileImageUrl,
    required super.email,
    required super.phoneNumber,
    required super.licenseNumber,
    required super.designation,
    required super.specialization,
    super.sex,
    super.dateOfBirth,
    required super.verificationStatus,
    required super.status,
    required super.prescriptionAuthority,
    required super.labImagingOrdering,
    required super.dischargeSignoffAuthority,
    required super.hospitalId,
    required super.hospitalName,
    super.lastLoginAt,
    super.createdAt,
    super.updatedAt,
  });

  factory DoctorDetailModel.fromJson(Map<String, dynamic> json) {
    return DoctorDetailModel(
      doctorId: json['doctorId'] as int,
      fullName: json['fullName'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String?,
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      licenseNumber: json['licenseNumber'] as String? ?? '',
      designation: _parseDesignation(json['designation'] as String?),
      specialization: json['specialization'] as String? ?? '',
      sex: _parseSex(json['sex'] as String?),
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'] as String)
          : null,
      verificationStatus: _parseVerification(json['verificationStatus'] as String?),
      status: _parseStatus(json['status'] as String?),
      prescriptionAuthority: json['prescriptionAuthority'] as bool? ?? false,
      labImagingOrdering: json['labImagingOrdering'] as bool? ?? false,
      dischargeSignoffAuthority: json['dischargeSignoffAuthority'] as bool? ?? false,
      hospitalId: json['hospitalId'] as int,
      hospitalName: json['hospitalName'] as String? ?? '',
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.tryParse(json['lastLoginAt'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }
}

Designation _parseDesignation(String? raw) {
  switch (raw) {
    case 'SENIOR_CONSULTANT':
      return Designation.seniorConsultant;
    case 'CONSULTANT':
      return Designation.consultant;
    case 'HOD':
      return Designation.hod;
    case 'ATTENDING_PHYSICIAN':
      return Designation.attendingPhysician;
    case 'RESIDENT_DOCTOR':
      return Designation.residentDoctor;
    default:
      return Designation.consultant;
  }
}

VerificationStatus _parseVerification(String? raw) {
  switch (raw) {
    case 'VERIFIED':
      return VerificationStatus.verified;
    case 'REJECTED':
      return VerificationStatus.rejected;
    default:
      return VerificationStatus.pending;
  }
}

DoctorStatus _parseStatus(String? raw) {
  switch (raw) {
    case 'ACTIVE':
      return DoctorStatus.active;
    case 'IN_OPD':
      return DoctorStatus.inOpd;
    case 'ON_CALL':
      return DoctorStatus.onCall;
    case 'ON_LEAVE':
      return DoctorStatus.onLeave;
    case 'INACTIVE':
      return DoctorStatus.inactive;
    default:
      return DoctorStatus.pendingFirstLogin;
  }
}

Sex? _parseSex(String? raw) {
  switch (raw) {
    case 'MALE':
      return Sex.male;
    case 'FEMALE':
      return Sex.female;
    case 'OTHER':
      return Sex.other;
    default:
      return null;
  }
}