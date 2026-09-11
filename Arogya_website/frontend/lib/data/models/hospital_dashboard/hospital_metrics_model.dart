// data/models/hospital/hospital_metrics_model.dart
import 'package:frontend/domain/entities/hosptial_dashboard/hospital_metrics_entity.dart';

class HospitalMetricsModel extends HospitalMetricsEntity {
  const HospitalMetricsModel({
    required super.totalStaff,
    required super.activeOnDuty,
    required super.pendingReviews,
    required super.specialtyCount,
  });

  factory HospitalMetricsModel.fromJson(Map<String, dynamic> json) {
    return HospitalMetricsModel(
      totalStaff: json['totalStaff'] as int,
      activeOnDuty: json['activeOnDuty'] as int,
      pendingReviews: json['pendingReviews'] as int,
      specialtyCount: json['specialtyCount'] as int,
    );
  }
}