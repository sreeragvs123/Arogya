part of 'patients_bloc.dart';

sealed class PatientsEvent extends Equatable {
  const PatientsEvent();

  @override
  List<Object?> get props => [];
}

class PatientsStarted extends PatientsEvent {
  const PatientsStarted();
}

class PatientsRefreshRequested extends PatientsEvent {
  const PatientsRefreshRequested();
}

class PatientsSearchChanged extends PatientsEvent {
  final String query;
  const PatientsSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class PatientsSortChanged extends PatientsEvent {
  final String sortBy;
  const PatientsSortChanged(this.sortBy);
  @override
  List<Object?> get props => [sortBy];
}

class PatientsConditionChanged extends PatientsEvent {
  final String condition;
  const PatientsConditionChanged(this.condition);
  @override
  List<Object?> get props => [condition];
}

class PatientsApplyFiltersPressed extends PatientsEvent {
  const PatientsApplyFiltersPressed();
}

class PatientsPageChanged extends PatientsEvent {
  final int page;
  const PatientsPageChanged(this.page);
  @override
  List<Object?> get props => [page];
}

class _PatientsListRequested extends PatientsEvent {
  const _PatientsListRequested();
}
