part of 'app_model_bloc.dart';

sealed class AppModelState extends Equatable {
  const AppModelState();
  
  @override
  List<Object> get props => [];
}

final class AppModelInitial extends AppModelState {}
