part of 'session_bloc.dart';

class SessionState extends Equatable {
  final DoctorSession? doctorSession;

  const SessionState({this.doctorSession});

  int? get doctorId => doctorSession?.doctorId;

  @override
  List<Object?> get props => [doctorSession];
}