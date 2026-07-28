part of 'meds_bloc.dart';

sealed class MedsState extends Equatable {
  const MedsState();
  
  @override
  List<Object> get props => [];
}

final class MedsInitial extends MedsState {}
