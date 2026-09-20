part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class DashboardStarted extends DashboardEvent {
  final int doctorid;
  const DashboardStarted({required this.doctorid});
}

class DashboardRefreshRequested extends DashboardEvent {
  final int doctorid;
  const DashboardRefreshRequested({required this.doctorid});
}

/// Fired when the doctor taps "Start Visit" or "Join Call" on a consultation.
class DashboardConsultationActionPressed extends DashboardEvent {
  final ConsultationEntity consultation;
  const DashboardConsultationActionPressed(this.consultation);
  @override
  List<Object?> get props => [consultation];
}
