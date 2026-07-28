part of 'weight_bloc.dart';

sealed class WeightState extends Equatable {
  const WeightState();
  
  @override
  List<Object> get props => [];
}

final class WeightInitial extends WeightState {}
