// data/models/hospital/doctor_summary_model.dart
import 'package:frontend/domain/entities/hosptial_dashboard/doctor_summary_entity.dart';

class DoctorSummaryModel extends DoctorSummaryEntity {
  const DoctorSummaryModel({
    required super.doctorId,
    required super.doctorName,
    super.profileImageUrl,
    required super.designation,
    required super.specialization,
    required super.licenseNumber,
    required super.verificationStatus,
    required super.hospitalId,
    required super.hospitalName,
    required super.wardOrDepartment,
    required super.status,
    required super.email,
    required super.phoneNumber,
    required super.prescriptionAuthority,
    required super.labImagingOrdering,
    required super.dischargeSignoffAuthority,
  });

  factory DoctorSummaryModel.fromJson(Map<String, dynamic> json) {
    return DoctorSummaryModel(
      doctorId: json['doctorId'] as int,
      doctorName: json['doctorName'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      designation: _designationFromString(json['designation'] as String),
      specialization: json['specialization'] as String,
      licenseNumber: json['licenseNumber'] as String,
      verificationStatus: _verificationFromString(json['verificationStatus'] as String),
      hospitalId: json['hospitalId'] as int,
      hospitalName: json['hospitalName'] as String,
      wardOrDepartment: json['wardOrDepartment'] as String,
      status: _statusFromString(json['status'] as String),
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      prescriptionAuthority: json['prescriptionAuthority'] as bool? ?? false,
      labImagingOrdering: json['labImagingOrdering'] as bool? ?? false,
      dischargeSignoffAuthority: json['dischargeSignoffAuthority'] as bool? ?? false,
    );
  }

  static Designation _designationFromString(String value) {
    switch (value.toUpperCase()) {
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
        return Designation.residentDoctor;
    }
  }

  static DoctorStatus _statusFromString(String value) {
    switch (value.toUpperCase()) {
      case 'ACTIVE':
        return DoctorStatus.active;
      case 'IN_OPD':
        return DoctorStatus.inOpd;
      case 'ON_CALL':
        return DoctorStatus.onCall;
      case 'ON_LEAVE':
        return DoctorStatus.onLeave;
      case 'PENDING_FIRST_LOGIN':
        return DoctorStatus.pendingFirstLogin;
      case 'INACTIVE':
        return DoctorStatus.inactive;
      default:
        return DoctorStatus.inactive;
    }
  }

  static VerificationStatus _verificationFromString(String value) {
    switch (value.toUpperCase()) {
      case 'VERIFIED':
        return VerificationStatus.verified;
      case 'PENDING':
        return VerificationStatus.pending;
      case 'REJECTED':
        return VerificationStatus.rejected;
      default:
        return VerificationStatus.pending;
    }
  }
}