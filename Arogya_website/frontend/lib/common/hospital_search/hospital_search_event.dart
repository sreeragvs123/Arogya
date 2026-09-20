part of 'hospital_search_bloc.dart';

sealed class HospitalSearchEvent extends Equatable {
  const HospitalSearchEvent();

  @override
  List<Object> get props => [];
}


class HospitalQueryChanged extends HospitalSearchEvent {
  final String query;
  const HospitalQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}