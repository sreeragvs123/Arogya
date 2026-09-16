part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class DashboardStarted extends DashboardEvent {
  const DashboardStarted();
}

class DashboardRefreshRequested extends DashboardEvent {
  const DashboardRefreshRequested();
}



/// Fired when the doctor taps "Start Visit" or "Join Call" on a consultation.
class DashboardConsultationActionPressed extends DashboardEvent {
  final ConsultationEntity consultation;
  const DashboardConsultationActionPressed(this.consultation);
  @override
  List<Object?> get props => [consultation];
}
