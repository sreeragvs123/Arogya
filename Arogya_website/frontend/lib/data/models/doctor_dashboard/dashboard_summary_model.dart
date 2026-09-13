import 'package:frontend/domain/entities/doctor_dashboard/dashboard_summary_entity.dart';

class MorningOverviewModel extends MorningOverviewEntity {
  const MorningOverviewModel({
    required super.consultationsToday,
    required super.capacityPercent,
  });

  factory MorningOverviewModel.fromJson(Map<String, dynamic> json) {
    return MorningOverviewModel(
      consultationsToday: json['consultationsToday'] as int,
      capacityPercent: json['capacityPercent'] as int,
    );
  }
}

class WeeklySummaryModel extends WeeklySummaryEntity {
  const WeeklySummaryModel({
    required super.efficiencyDeltaPercent,
    required super.progress,
  });

  factory WeeklySummaryModel.fromJson(Map<String, dynamic> json) {
    return WeeklySummaryModel(
      efficiencyDeltaPercent: json['efficiencyDeltaPercent'] as int,
      progress: (json['progress'] as num).toDouble(),
    );
  }
}

class DashboardSummaryModel extends DashboardSummaryEntity {
  const DashboardSummaryModel({
    required super.morningOverview,
    required super.pendingReportsCount,
    required super.newReportsCount,
    required super.criticalAlertsCount,
    required super.weeklySummary,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      morningOverview:
          MorningOverviewModel.fromJson(json['morningOverview'] as Map<String, dynamic>),
      pendingReportsCount: json['pendingReportsCount'] as int,
      newReportsCount: json['newReportsCount'] as int,
      criticalAlertsCount: json['criticalAlertsCount'] as int,
      weeklySummary: WeeklySummaryModel.fromJson(json['weeklySummary'] as Map<String, dynamic>),
    );
  }
}
