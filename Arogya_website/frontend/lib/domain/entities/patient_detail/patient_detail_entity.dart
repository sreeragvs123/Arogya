import 'package:equatable/equatable.dart';

class PatientDetailEntity extends Equatable {
  final String id;
  final String name;
  final String displayId; // e.g. "AR-9920-X"
  final bool isHighSensitivity;
  final int age;
  final String gender;
  final String bloodGroup;
  final String heightCm;
  final String weightKg;
  final String? photoUrl;

  const PatientDetailEntity({
    required this.id,
    required this.name,
    required this.displayId,
    required this.age,
    required this.gender,
    required this.bloodGroup,
    required this.heightCm,
    required this.weightKg,
    this.isHighSensitivity = false,
    this.photoUrl,
  });

  @override
  List<Object?> get props =>
      [id, name, displayId, isHighSensitivity, age, gender, bloodGroup, heightCm, weightKg, photoUrl];
}

class VitalsEntity extends Equatable {
  final int heartRateBpm;
  final String heartRateStatus; // e.g. "STABLE"
  final List<double> heartRateTrend;
  final String bloodPressure; // "118/79"
  final String bloodPressureStatus; // e.g. "OK"
  final double bodyTempF;
  final double? bloodSugar;
  final double? weightKg;
  final double? heightCm;

  const VitalsEntity({
    required this.heartRateBpm,
    required this.heartRateStatus,
    required this.heartRateTrend,
    required this.bloodPressure,
    required this.bloodPressureStatus,
    required this.bodyTempF,
    this.bloodSugar,
    this.weightKg,
    this.heightCm,
  });

  @override
  List<Object?> get props => [
        heartRateBpm,
        heartRateStatus,
        heartRateTrend,
        bloodPressure,
        bloodPressureStatus,
        bodyTempF,
        bloodSugar,
        weightKg,
        heightCm,
      ];
}

class ObservationEntity extends Equatable {
  final String date;
  final String note;

  const ObservationEntity({required this.date, required this.note});

  @override
  List<Object?> get props => [date, note];
}

class PrescriptionItemEntity extends Equatable {
  final String id;
  final String name;
  final String dosage;
  final String frequency;
  final String timing;

  const PrescriptionItemEntity({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.timing,
  });

  String get displaySchedule => '$frequency • $timing';
  String get displayName => dosage.isEmpty ? name : '$name $dosage';

  @override
  List<Object?> get props => [id, name, dosage, frequency, timing];
}

class ClinicalReportEntity extends Equatable {
  final String sessionDuration;
  final String reportDate;
  final String reportRef;
  final bool signaturePending;

  const ClinicalReportEntity({
    required this.sessionDuration,
    required this.reportDate,
    required this.reportRef,
    this.signaturePending = true,
  });

  ClinicalReportEntity copyWith({bool? signaturePending}) {
    return ClinicalReportEntity(
      sessionDuration: sessionDuration,
      reportDate: reportDate,
      reportRef: reportRef,
      signaturePending: signaturePending ?? this.signaturePending,
    );
  }

  @override
  List<Object?> get props => [sessionDuration, reportDate, reportRef, signaturePending];
}
