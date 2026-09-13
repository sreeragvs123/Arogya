import 'package:equatable/equatable.dart';

class MorningOverviewEntity extends Equatable {
  final int consultationsToday;
  final int capacityPercent;

  const MorningOverviewEntity({
    required this.consultationsToday,
    required this.capacityPercent,
  });

  @override
  List<Object?> get props => [consultationsToday, capacityPercent];
}

class WeeklySummaryEntity extends Equatable {
  final int efficiencyDeltaPercent;
  final double progress; // 0.0 - 1.0

  const WeeklySummaryEntity({
    required this.efficiencyDeltaPercent,
    required this.progress,
  });

  @override
  List<Object?> get props => [efficiencyDeltaPercent, progress];
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
  List<Object?> get props =>
      [morningOverview, pendingReportsCount, newReportsCount, criticalAlertsCount, weeklySummary];
}
