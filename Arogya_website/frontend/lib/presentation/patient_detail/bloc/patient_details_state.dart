part of 'patient_details_bloc.dart';

sealed class PatientDetailsState extends Equatable {
  const PatientDetailsState();
  
  @override
  List<Object> get props => [];
}

final class PatientDetailsInitial extends PatientDetailsState {}
