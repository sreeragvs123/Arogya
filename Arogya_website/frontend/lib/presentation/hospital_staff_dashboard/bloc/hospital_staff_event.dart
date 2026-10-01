part of 'hospital_staff_bloc.dart';

sealed class HospitalStaffEvent extends Equatable {
  const HospitalStaffEvent();
  @override
  List<Object?> get props => [];
}

class StaffStarted extends HospitalStaffEvent {
  final int hospitalId;
  const StaffStarted(this.hospitalId);
  @override
  List<Object?> get props => [hospitalId];
}

class StaffPageChanged extends HospitalStaffEvent {
  final int page;
  const StaffPageChanged(this.page);
  @override
  List<Object?> get props => [page];
}