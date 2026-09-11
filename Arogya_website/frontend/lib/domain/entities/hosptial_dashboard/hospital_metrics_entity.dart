// domain/entities/hospital/hospital_metrics_entity.dart
import 'package:equatable/equatable.dart';

class HospitalMetricsEntity extends Equatable {
  final int totalStaff;
  final int activeOnDuty;
  final int pendingReviews;
  final int specialtyCount;

  const HospitalMetricsEntity({
    required this.totalStaff,
    required this.activeOnDuty,
    required this.pendingReviews,
    required this.specialtyCount,
  });

  @override
  List<Object?> get props => [totalStaff, activeOnDuty, pendingReviews, specialtyCount];
}