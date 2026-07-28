part of 'blood_sugar_bloc.dart';

sealed class BloodSugarState extends Equatable {
  const BloodSugarState();
  
  @override
  List<Object> get props => [];
}

final class BloodSugarInitial extends BloodSugarState {}
