part of 'blood_pressure_bloc.dart';

sealed class BloodPressureState extends Equatable {
  const BloodPressureState();
  
  @override
  List<Object> get props => [];
}

final class BloodPressureInitial extends BloodPressureState {}
