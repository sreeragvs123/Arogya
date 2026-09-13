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
      id: json['id'].toString(),
      name: json['name'] as String,
      patientId: json['patientId'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      status: json['status'] as String,
      lastVisit: json['lastVisit'] as String,
      diagnosis: json['diagnosis'] as String,
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
      totalPatients: json['totalPatients'] as int,
      totalPatientsGrowth: json['totalPatientsGrowth'] as String,
      newThisMonth: json['newThisMonth'] as int,
      followUpsPending: json['followUpsPending'] as int,
    );
  }
}
