// domain/entities/hospital/doctor_staff_section.dart
enum DoctorStaffSection { allStaff, activeDuty, onCall, provisioning }

extension DoctorStaffSectionX on DoctorStaffSection {
  String get apiValue {
    switch (this) {
      case DoctorStaffSection.allStaff:
        return 'ALL_STAFF';
      case DoctorStaffSection.activeDuty:
        return 'ACTIVE_DUTY';
      case DoctorStaffSection.onCall:
        return 'ON_CALL';
      case DoctorStaffSection.provisioning:
        return 'PROVISIONING';
    }
  }

  static DoctorStaffSection fromTabKey(String key) {
    switch (key) {
      case 'active':
        return DoctorStaffSection.activeDuty;
      case 'on_call':
        return DoctorStaffSection.onCall;
      case 'pending':
        return DoctorStaffSection.provisioning;
      default:
        return DoctorStaffSection.allStaff;
    }
  }
}