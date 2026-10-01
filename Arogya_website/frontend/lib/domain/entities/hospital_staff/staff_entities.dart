import 'package:equatable/equatable.dart';
import 'staff_enums.dart';

class StaffSummaryEntity extends Equatable {
  final int id;
  final String name, email, phoneNumber, role;
  final String? profileImageUrl;
  final Department? department;
  final bool isActive, onCall;
  final DateTime? lastLoginAt;

  const StaffSummaryEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.profileImageUrl,
    this.department,
    required this.isActive,
    required this.onCall,
    this.lastLoginAt,
  });

  @override
  List<Object?> get props => [id, name, email, phoneNumber, role, profileImageUrl, department, isActive, onCall, lastLoginAt];
}

class CreateStaffParams {
  final int hospitalId;
  final String fullName, email, employeeId, phoneNumber, address, temporaryPin;
  final Sex sex;
  final DateTime dateOfBirth;
  final Department department;

  const CreateStaffParams({
    required this.hospitalId,
    required this.fullName,
    required this.email,
    required this.employeeId,
    required this.phoneNumber,
    required this.address,
    required this.sex,
    required this.dateOfBirth,
    required this.department,
    required this.temporaryPin,
  });

  // Matches StaffCreateRequestDto
  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'employeeId': employeeId,
        'phoneNumber': phoneNumber,
        'address': address,
        'sex': sex.name,
        'dateOfBirth': dateOfBirth.toIso8601String().split('T').first,
        'department': department.name,
        'temporaryPin': temporaryPin,
      };
}