class ClinicalPrivileges {
  final bool prescriptionAuthority;
  final bool labOrdering;
  final bool dischargeSignoff;

  const ClinicalPrivileges({
    this.prescriptionAuthority = true,
    this.labOrdering = true,
    this.dischargeSignoff = false,
  });
}

class DoctorSummary {
  final String id;
  final String name;
  final bool isVerified;
  final bool isPending;
  final bool councilVerified;
  final String license;
  final String hospitalAffiliation;
  final String department;
  final String role;
  final String systemId;
  final String email;
  final String phone;
  final String status; // 'active', 'opd', 'on_call', 'pending'
  final String statusLabel;
  final String? opdRoom;
  final dynamic caseload;
  final String caseloadLabel;
  final String? temporaryPin;
  final ClinicalPrivileges privileges;

  /// Formatted caseload display safe for Flutter Text widgets (handles int and String)
  String get formattedCaseload {
    if (caseload is num) {
      return '$caseload $caseloadLabel';
    }
    return caseload?.toString() ?? '-';
  }

  const DoctorSummary({
    required this.id,
    required this.name,
    this.isVerified = false,
    this.isPending = false,
    this.councilVerified = false,
    required this.license,
    required this.hospitalAffiliation,
    required this.department,
    required this.role,
    required this.systemId,
    required this.email,
    required this.phone,
    required this.status,
    required this.statusLabel,
    this.opdRoom,
    required this.caseload,
    required this.caseloadLabel,
    this.temporaryPin,
    this.privileges = const ClinicalPrivileges(),
  });

  factory DoctorSummary.fromJson(Map<String, dynamic> json) {
    final bool isActive = json['isActive'] ?? true;
    final String status = isActive ? 'active' : 'pending';
    final String statusLabel = isActive ? 'Active Today' : 'Pending Verification';

    return DoctorSummary(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      isVerified: true,
      councilVerified: true,
      license: json['licenseNumber'] ?? '',
      hospitalAffiliation: json['hospitalAffiliation'] ?? 'Hospital Unit',
      department: json['department'] ?? 'General',
      role: json['designation']?.toString().replaceAll('_', ' ') ?? 'Consultant',
      systemId: json['systemId'] ?? 'DOC-0000',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      status: status,
      statusLabel: statusLabel,
      caseload: 0,
      caseloadLabel: 'Active Cases',
    );
  }

  static const List<DoctorSummary> sampleDoctors = [
    DoctorSummary(
      id: 'DOC-4820',
      name: 'Dr. Rajesh Koothrappali, MD',
      isVerified: true,
      councilVerified: true,
      license: 'Lic: MCI-2018-94821',
      hospitalAffiliation: 'Apollo Cardiology',
      department: 'Cardiology',
      role: 'Senior Consultant',
      systemId: 'DOC-4820',
      email: 'r.koothrappali@apollohealth.org',
      phone: '+91 98451 22314',
      status: 'active',
      statusLabel: 'Active Today',
      caseload: 34,
      caseloadLabel: 'Active Cases',
      temporaryPin: 'AP-9482-TX',
    ),
    DoctorSummary(
      id: 'DOC-1904',
      name: 'Dr. Sunita Varma, DM',
      isVerified: true,
      councilVerified: true,
      license: 'Lic: KMC-2015-11029',
      hospitalAffiliation: 'Neurosciences Block',
      department: 'Neurology',
      role: 'Head of Department (HOD)',
      systemId: 'DOC-1904',
      email: 's.varma@apollohealth.org',
      phone: '+91 98452 11094',
      status: 'opd',
      statusLabel: 'In OPD (Room 304)',
      caseload: 28,
      caseloadLabel: 'Active Cases',
    ),
    DoctorSummary(
      id: 'DOC-9382',
      name: 'Dr. Farhan Qureshi, MS',
      isVerified: false,
      councilVerified: false,
      license: 'Lic: MCI-2022-77182',
      hospitalAffiliation: 'Orthopedics',
      department: 'Orthopedics',
      role: 'Resident Doctor',
      systemId: 'DOC-9382',
      email: 'f.qureshi@apollohealth.org',
      phone: '+91 98453 93820',
      status: 'on_call',
      statusLabel: 'On Call Duty',
      caseload: 19,
      caseloadLabel: 'Active Cases',
    ),
    DoctorSummary(
      id: 'DOC-5011',
      name: 'Dr. Aisha Naidu, DNB',
      isPending: true,
      councilVerified: false,
      license: 'Lic: MCI-2023-89102',
      hospitalAffiliation: 'Pediatrics',
      department: 'Pediatrics',
      role: 'Attending Physician',
      systemId: 'DOC-5011',
      email: 'a.naidu@apollohealth.org',
      phone: '+91 98454 50112',
      status: 'pending',
      statusLabel: 'Pending First Login',
      caseload: '- New Provision',
      caseloadLabel: '- New Provision',
      temporaryPin: 'AP-5011-AN',
    ),
    DoctorSummary(
      id: 'DOC-2109',
      name: 'Dr. K. S. Ramanujam, MD',
      isVerified: true,
      councilVerified: true,
      license: 'Lic: TMC-2010-00412',
      hospitalAffiliation: 'Medical Oncology',
      department: 'Oncology',
      role: 'Senior Consultant',
      systemId: 'DOC-2109',
      email: 'k.ramanujam@apollohealth.org',
      phone: '+91 98455 21093',
      status: 'active',
      statusLabel: 'Active Today',
      caseload: 42,
      caseloadLabel: 'Active Cases',
    ),
  ];
}
