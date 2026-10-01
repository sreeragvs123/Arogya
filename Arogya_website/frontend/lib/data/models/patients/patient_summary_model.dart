import 'package:frontend/domain/entities/patients/patient_summary_entity.dart';

class PatientSummaryModel extends PatientSummaryEntity {
  const PatientSummaryModel({
    required super.id,
    required super.name,
    required super.patientId,
    required super.age,
    required super.gender,
    required super.status,
    required super.lastVisit,
    required super.diagnosis,
    super.isHighRisk,
  });

  factory PatientSummaryModel.fromJson(Map<String, dynamic> json) {
    return PatientSummaryModel(
      id: (json['id'] ?? json['patientId'])?.toString() ?? '',
      name: (json['name'] ?? json['patientName'])?.toString() ?? 'Patient',
      patientId: (json['patientId'] ?? json['id'])?.toString() ?? '',
      age: (json['age'] as num?)?.toInt() ?? 0,
      gender: (json['gender'] as String?) ?? 'N/A',
      status: (json['status'] ?? json['directoryStatus']) as String? ?? 'Active',
      lastVisit: (json['lastVisit'] ?? json['lastVisitedAt'])?.toString() ?? '',
      diagnosis: (json['diagnosis'] ?? json['primaryDiagnosis']) as String? ?? 'N/A',
      isHighRisk: json['isHighRisk'] as bool? ?? false,
    );
  }
}

class PatientsDirectorySummaryModel extends PatientsDirectorySummaryEntity {
  const PatientsDirectorySummaryModel({
    required super.totalPatients,
    required super.totalPatientsGrowth,
    required super.newThisMonth,
    required super.followUpsPending,
  });

  factory PatientsDirectorySummaryModel.fromJson(Map<String, dynamic> json) {
    return PatientsDirectorySummaryModel(
      totalPatients: (json['totalPatients'] as num?)?.toInt() ?? 0,
      totalPatientsGrowth: (json['totalPatientsGrowth'] as String?) ?? '+0%',
      newThisMonth: (json['newThisMonth'] ?? json['newPatientsThisMonth'] as num?)?.toInt() ?? 0,
      followUpsPending: (json['followUpsPending'] ?? json['followUpsDue'] as num?)?.toInt() ?? 0,
    );
  }
}
