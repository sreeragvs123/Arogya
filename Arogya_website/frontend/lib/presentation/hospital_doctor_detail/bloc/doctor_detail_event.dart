// doctor_detail_event.dart
part of 'doctor_detail_bloc.dart';

sealed class DoctorDetailEvent extends Equatable {
  const DoctorDetailEvent();
  @override
  List<Object?> get props => [];
}

class DoctorDetailStarted extends DoctorDetailEvent {
  final int hospitalId;
  final int doctorId;
  const DoctorDetailStarted({required this.hospitalId, required this.doctorId});
  @override
  List<Object?> get props => [hospitalId, doctorId];
}