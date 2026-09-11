// presentation/hospital_dashboard/bloc/hospital_dashboard_event.dart
part of 'hospital_dashboard_bloc.dart';

sealed class HospitalDashboardEvent extends Equatable {
  const HospitalDashboardEvent();
  @override
  List<Object?> get props => [];
}

class HospitalDashboardStarted extends HospitalDashboardEvent {
  final int hospitalId;
  const HospitalDashboardStarted(this.hospitalId);
  @override
  List<Object?> get props => [hospitalId];
}

class HospitalDashboardSearchChanged extends HospitalDashboardEvent {
  final String query;
  const HospitalDashboardSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class HospitalDashboardTabChanged extends HospitalDashboardEvent {
  final String tabKey; // all, active, on_call, pending
  const HospitalDashboardTabChanged(this.tabKey);
  @override
  List<Object?> get props => [tabKey];
}

class HospitalDashboardDepartmentChanged extends HospitalDashboardEvent {
  final String department;
  const HospitalDashboardDepartmentChanged(this.department);
  @override
  List<Object?> get props => [department];
}

class HospitalDashboardPageChanged extends HospitalDashboardEvent {
  final int page;
  const HospitalDashboardPageChanged(this.page);
  @override
  List<Object?> get props => [page];
}

class _HospitalDashboardDoctorsRequested extends HospitalDashboardEvent {
  const _HospitalDashboardDoctorsRequested();
}