part of 'health_log_bloc.dart';

sealed class HealthLogState extends Equatable {
  const HealthLogState();
  
  @override
  List<Object> get props => [];
}

final class HealthLogInitial extends HealthLogState {}
