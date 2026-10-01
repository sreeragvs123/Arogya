import 'package:frontend/domain/entities/hospital_staff/staff_entities.dart';
import 'package:frontend/domain/entities/hospital_staff/staff_enums.dart';

class StaffSummaryModel extends StaffSummaryEntity {
  const StaffSummaryModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phoneNumber,
    required super.role,
    super.profileImageUrl,
    super.department,
    required super.isActive,
    required super.onCall,
    super.lastLoginAt,
  });

  factory StaffSummaryModel.fromJson(Map<String, dynamic> json) {
    final dept = (json['department'] as String?)?.toUpperCase();
    return StaffSummaryModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      role: json['role'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String?,
      department: Department.values.where((d) => d.name == dept).firstOrNull,
      isActive: (json['isActive'] ?? json['active']) as bool? ?? false,
      onCall: json['onCall'] as bool? ?? false,
      lastLoginAt: DateTime.tryParse(json['lastLoginAt'] as String? ?? ''),
    );
  }
}