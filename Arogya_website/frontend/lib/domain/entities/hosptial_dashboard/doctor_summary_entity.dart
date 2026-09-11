// domain/entities/hospital/doctor_summary_entity.dart
import 'package:equatable/equatable.dart';

enum Designation { seniorConsultant, consultant, hod, attendingPhysician, residentDoctor }

enum DoctorStatus { active, inOpd, onCall, onLeave, pendingFirstLogin, inactive }

enum VerificationStatus { verified, pending, rejected }

class DoctorSummaryEntity extends Equatable {
  final int doctorId;
  final String doctorName;
  final String? profileImageUrl;
  final Designation designation;
  final String specialization;

  final String licenseNumber;
  final VerificationStatus verificationStatus;

  final int hospitalId;
  final String hospitalName;
  final String wardOrDepartment;

  final DoctorStatus status;

  final String email;
  final String phoneNumber;

  final bool prescriptionAuthority;
  final bool labImagingOrdering;
  final bool dischargeSignoffAuthority;

  const DoctorSummaryEntity({
    required this.doctorId,
    required this.doctorName,
    this.profileImageUrl,
    required this.designation,
    required this.specialization,
    required this.licenseNumber,
    required this.verificationStatus,
    required this.hospitalId,
    required this.hospitalName,
    required this.wardOrDepartment,
    required this.status,
    required this.email,
    required this.phoneNumber,
    required this.prescriptionAuthority,
    required this.labImagingOrdering,
    required this.dischargeSignoffAuthority,
  });

  @override
  List<Object?> get props => [
        doctorId,
        doctorName,
        profileImageUrl,
        designation,
        specialization,
        licenseNumber,
        verificationStatus,
        hospitalId,
        hospitalName,
        wardOrDepartment,
        status,
        email,
        phoneNumber,
        prescriptionAuthority,
        labImagingOrdering,
        dischargeSignoffAuthority,
      ];
}