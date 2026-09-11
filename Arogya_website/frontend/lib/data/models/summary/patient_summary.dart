class PatientSummary {
  final String name;
  final String patientId;
  final int age;
  final String gender;
  final String status;
  final String lastVisit;
  final String diagnosis;
  final bool isHighRisk;

  const PatientSummary({
    required this.name,
    required this.patientId,
    required this.age,
    required this.gender,
    required this.status,
    required this.lastVisit,
    required this.diagnosis,
    this.isHighRisk = false,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }
}