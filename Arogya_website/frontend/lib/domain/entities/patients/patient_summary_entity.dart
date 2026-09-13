import 'package:equatable/equatable.dart';

class PatientSummaryEntity extends Equatable {
  final String id;
  final String name;
  final String patientId; // display id, e.g. "PID: 90211-BX"
  final int age;
  final String gender;
  final String status;
  final String lastVisit;
  final String diagnosis;
  final bool isHighRisk;

  const PatientSummaryEntity({
    required this.id,
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
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  @override
  List<Object?> get props =>
      [id, name, patientId, age, gender, status, lastVisit, diagnosis, isHighRisk];
}

class PatientsDirectorySummaryEntity extends Equatable {
  final int totalPatients;
  final String totalPatientsGrowth;
  final int newThisMonth;
  final int followUpsPending;

  const PatientsDirectorySummaryEntity({
    required this.totalPatients,
    required this.totalPatientsGrowth,
    required this.newThisMonth,
    required this.followUpsPending,
  });

  @override
  List<Object?> get props => [totalPatients, totalPatientsGrowth, newThisMonth, followUpsPending];
}
