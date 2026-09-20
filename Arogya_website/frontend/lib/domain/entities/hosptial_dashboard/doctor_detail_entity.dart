import 'package:equatable/equatable.dart';
import 'package:frontend/domain/entities/hosptial_dashboard/doctor_summary_entity.dart';

enum Sex { male, female, other }

class DoctorDetailEntity extends Equatable {
  final int doctorId;
  final String fullName;
  final String? profileImageUrl;
  final String email;
  final String phoneNumber;
  final String licenseNumber;
  final Designation designation;
  final String specialization;
  final Sex? sex;
  final DateTime? dateOfBirth;
  final VerificationStatus verificationStatus;
  final DoctorStatus status;
  final bool prescriptionAuthority;
  final bool labImagingOrdering;
  final bool dischargeSignoffAuthority;
  final int hospitalId;
  final String hospitalName;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DoctorDetailEntity({
    required this.doctorId,
    required this.fullName,
    this.profileImageUrl,
    required this.email,
    required this.phoneNumber,
    required this.licenseNumber,
    required this.designation,
    required this.specialization,
    this.sex,
    this.dateOfBirth,
    required this.verificationStatus,
    required this.status,
    required this.prescriptionAuthority,
    required this.labImagingOrdering,
    required this.dischargeSignoffAuthority,
    required this.hospitalId,
    required this.hospitalName,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        doctorId, fullName, profileImageUrl, email, phoneNumber, licenseNumber,
        designation, specialization, sex, dateOfBirth, verificationStatus, status,
        prescriptionAuthority, labImagingOrdering, dischargeSignoffAuthority,
        hospitalId, hospitalName, lastLoginAt, createdAt, updatedAt,
      ];
}