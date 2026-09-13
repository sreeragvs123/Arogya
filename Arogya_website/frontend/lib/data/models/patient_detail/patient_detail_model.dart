import 'package:frontend/domain/entities/patient_detail/patient_detail_entity.dart';

class PatientDetailModel extends PatientDetailEntity {
  const PatientDetailModel({
    required super.id,
    required super.name,
    required super.displayId,
    required super.age,
    required super.gender,
    required super.bloodGroup,
    required super.heightCm,
    required super.weightKg,
    super.isHighSensitivity,
    super.photoUrl,
  });

  factory PatientDetailModel.fromJson(Map<String, dynamic> json) {
    return PatientDetailModel(
      id: json['id'].toString(),
      name: json['name'] as String,
      displayId: json['displayId'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      bloodGroup: json['bloodGroup'] as String,
      heightCm: json['heightCm'] as String,
      weightKg: json['weightKg'] as String,
      isHighSensitivity: json['isHighSensitivity'] as bool? ?? false,
      photoUrl: json['photoUrl'] as String?,
    );
  }
}

class VitalsModel extends VitalsEntity {
  const VitalsModel({
    required super.heartRateBpm,
    required super.heartRateStatus,
    required super.heartRateTrend,
    required super.bloodPressure,
    required super.bloodPressureStatus,
    required super.bodyTempF,
    super.bloodSugar,
    super.weightKg,
    super.heightCm,
  });

  factory VitalsModel.fromJson(Map<String, dynamic> json) {
    return VitalsModel(
      heartRateBpm: json['heartRateBpm'] as int,
      heartRateStatus: json['heartRateStatus'] as String? ?? 'STABLE',
      heartRateTrend: (json['heartRateTrend'] as List?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          const [0.4, 0.55, 0.5, 0.75, 0.6, 0.5],
      bloodPressure: json['bloodPressure'] as String,
      bloodPressureStatus: json['bloodPressureStatus'] as String? ?? 'OK',
      bodyTempF: (json['bodyTempF'] as num).toDouble(),
      bloodSugar: (json['bloodSugar'] as num?)?.toDouble(),
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      heightCm: (json['heightCm'] as num?)?.toDouble(),
    );
  }
}

class ObservationModel extends ObservationEntity {
  const ObservationModel({required super.date, required super.note});

  factory ObservationModel.fromJson(Map<String, dynamic> json) {
    return ObservationModel(
      date: json['date'] as String,
      note: json['note'] as String,
    );
  }
}

class PrescriptionItemModel extends PrescriptionItemEntity {
  const PrescriptionItemModel({
    required super.id,
    required super.name,
    required super.dosage,
    required super.frequency,
    required super.timing,
  });

  factory PrescriptionItemModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionItemModel(
      id: json['id'].toString(),
      name: json['name'] as String,
      dosage: json['dosage'] as String? ?? '',
      frequency: json['frequency'] as String? ?? '',
      timing: json['timing'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'dosage': dosage,
        'frequency': frequency,
        'timing': timing,
      };
}

class ClinicalReportModel extends ClinicalReportEntity {
  const ClinicalReportModel({
    required super.sessionDuration,
    required super.reportDate,
    required super.reportRef,
    super.signaturePending,
  });

  factory ClinicalReportModel.fromJson(Map<String, dynamic> json) {
    return ClinicalReportModel(
      sessionDuration: json['sessionDuration'] as String,
      reportDate: json['reportDate'] as String,
      reportRef: json['reportRef'] as String,
      signaturePending: json['signaturePending'] as bool? ?? true,
    );
  }
}
