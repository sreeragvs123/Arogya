part of 'staff_dashboard_bloc.dart';

sealed class StaffDashboardState extends Equatable {
  const StaffDashboardState();
  
  @override
  List<Object> get props => [];
}

final class StaffDashboardInitial extends StaffDashboardState {}
