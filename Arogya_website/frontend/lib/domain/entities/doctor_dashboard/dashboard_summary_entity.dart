import 'package:equatable/equatable.dart';

class MorningOverviewEntity extends Equatable {
  final int consultationsToday;
  final double capacityPercent;

  const MorningOverviewEntity({
    required this.consultationsToday,
    required this.capacityPercent,
  });

  @override
  List<Object?> get props => [consultationsToday, capacityPercent];
}

class WeeklySummaryEntity extends Equatable {
  final double efficiencyPercentDelta;
  final double progress;
  final int completedConsultations;
  final int scheduledConsultations;

  const WeeklySummaryEntity({
    required this.efficiencyPercentDelta,
    required this.progress,
    required this.completedConsultations,
    required this.scheduledConsultations,
  });

  @override
  List<Object?> get props => [
        efficiencyPercentDelta,
        progress,
        completedConsultations,
        scheduledConsultations,
      ];
}

class DashboardSummaryEntity extends Equatable {
  final MorningOverviewEntity morningOverview;
  final int pendingReportsCount;
  final int newReportsCount;
  final int criticalAlertsCount;
  final WeeklySummaryEntity weeklySummary;

  const DashboardSummaryEntity({
    required this.morningOverview,
    required this.pendingReportsCount,
    required this.newReportsCount,
    required this.criticalAlertsCount,
    required this.weeklySummary,
  });

  @override
  List<Object?> get props => [
        morningOverview,
        pendingReportsCount,
        newReportsCount,
        criticalAlertsCount,
        weeklySummary,
      ];
}