import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/core/error/failures.dart';
import 'package:frontend/domain/entities/patient_detail/patient_detail_entity.dart';

class VitalsUpdateInput extends Equatable {
  final String? heartRateBpm;
  final String? bloodPressure;
  final String? bodyTempF;
  final String? bloodSugar;
  final String? weightKg;
  final String? heightCm;

  const VitalsUpdateInput({
    this.heartRateBpm,
    this.bloodPressure,
    this.bodyTempF,
    this.bloodSugar,
    this.weightKg,
    this.heightCm,
  });

  Map<String, dynamic> toJson() => {
        if (heartRateBpm != null && heartRateBpm!.isNotEmpty) 'heartRateBpm': heartRateBpm,
        if (bloodPressure != null && bloodPressure!.isNotEmpty) 'bloodPressure': bloodPressure,
        if (bodyTempF != null && bodyTempF!.isNotEmpty) 'bodyTempF': bodyTempF,
        if (bloodSugar != null && bloodSugar!.isNotEmpty) 'bloodSugar': bloodSugar,
        if (weightKg != null && weightKg!.isNotEmpty) 'weightKg': weightKg,
        if (heightCm != null && heightCm!.isNotEmpty) 'heightCm': heightCm,
      };

  @override
  List<Object?> get props =>
      [heartRateBpm, bloodPressure, bodyTempF, bloodSugar, weightKg, heightCm];
}

abstract class PatientDetailRepository {
  Future<Either<Failure, PatientDetailEntity>> getPatientDetail({required String patientId});

  Future<Either<Failure, VitalsEntity>> getVitals({required String patientId});

  Future<Either<Failure, List<ObservationEntity>>> getRecentObservations({
    required String patientId,
  });

  Future<Either<Failure, VitalsEntity>> updateVitals({
    required String patientId,
    required VitalsUpdateInput input,
  });

  Future<Either<Failure, Unit>> saveObservations({
    required String patientId,
    required List<String> symptoms,
    required String clinicalNote,
  });

  Future<Either<Failure, List<PrescriptionItemEntity>>> getPrescriptionDraft({
    required String patientId,
  });

  Future<Either<Failure, Unit>> savePrescription({
    required String patientId,
    required List<PrescriptionItemEntity> items,
  });

  Future<Either<Failure, ClinicalReportEntity>> generateClinicalReport({
    required String patientId,
  });
}
