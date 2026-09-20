import 'package:frontend/domain/entities/doctor_dashboard/dashboard_summary_entity.dart';


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



class MorningOverviewModel extends MorningOverviewEntity {
  
  const MorningOverviewModel({
    required super.consultationsToday,
    required super.capacityPercent,
  });

  factory MorningOverviewModel.fromJson(Map<String, dynamic> json) {
    return MorningOverviewModel(
      consultationsToday: (json['consultationsToday'] as num).toInt(),
      capacityPercent: (json['capacityPercent'] as num).toDouble(),
    );
  }
}




class WeeklySummaryModel extends WeeklySummaryEntity {
  const WeeklySummaryModel({
    required super.efficiencyPercentDelta,
    required super.progress,
    required super.completedConsultations,
    required super.scheduledConsultations,
  });

  factory WeeklySummaryModel.fromJson(Map<String, dynamic> json) {
    return WeeklySummaryModel(
      efficiencyPercentDelta:
          (json['efficiencyPercentDelta'] as num).toDouble(),
      progress: (json['progress'] as num).toDouble(),
      completedConsultations:
          (json['completedConsultations'] as num).toInt(),
      scheduledConsultations:
          (json['scheduledConsultations'] as num).toInt(),
    );
  }
}


